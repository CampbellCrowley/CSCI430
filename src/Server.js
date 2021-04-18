// Author: Campbell Crowley (github@campbellcrowley.com).
// February, 2021
const express = require('express');
const compression = require('compression');
const bodyParser = require('body-parser');
const DataServer = require('./DataServer.js');
const DataReceiver = require('./DataReceiver.js');
const Authenticator = require('./Authenticator.js');

/**
 * Front-end server for user-request handling.
 * @class
 */
class Server {
  /**
   * Constructor.
   * @param {{port: number, address: string}} [host] Host info to bind to.
   */
  constructor(host={}) {
    /**
     * Port server will listen on.
     *
     * @private
     * @constant
     * @type {number}
     * @default 8080
     */
    this._port = host.port ?? 8080;
    /**
     * Address server will listen on.
     *
     * @private
     * @constant
     * @type {string}
     * @default '127.0.0.1'
     */
    this._address = host.address ?? '127.0.0.1';
    /**
     * Express app instance.
     *
     * @private
     * @constant
     * @type {express.Application}
     */
    this._app = express();
    /**
     * Listening Express server instance.
     *
     * @private
     * @type {?http.Server}
     * @default
     */
    this._server = null;
    /**
     * Instance of Authenticator.
     *
     * @private
     * @constant
     * @type {Authenticator}
     */
    this._authenticator = new Authenticator();
    /**
     * Instance of DataServer.
     *
     * @private
     * @constant
     * @type {DataServer}
     */
    this._dataServer = new DataServer();
    /**
     * Instance of DataReceiver.
     *
     * @private
     * @constant
     * @type {DataReceiver}
     */
    this._dataReceiver = new DataReceiver(this._authenticator);
  }
  /**
   * Start the server, and begin handling requests.
   * @public
   */
  run() {
    this._registerEndpoints();
    this._app.enable('trust proxy');

    this._server = this._app.listen(this._port, () => {
      console.log(`Hello World! Server started on port ${this._port}`);
    });
  }
  /**
   * Stop the server, and prepare to be terminated.
   * @public
   */
  shutdown() {
    this._app.disable('trust proxy');
    this._server.close();
  }

  /**
   * Register endpoint handlers with Express.
   * @private
   */
  _registerEndpoints() {
    this._app.use(compression());
    this._app.use(bodyParser.json());
    this._app.use(bodyParser.text());

    this._app.use((err, req, res, next) => {
      if (err) {
        console.error('Encountered error while handing request:');
        console.error(err);
        if (err instanceof SyntaxError) {
          res.status(400).json({error: 'Syntax Error', code: 400});
          console.error(
              `${req.method} ${res.statusCode} ${req.originalUrl} ${req.ip}`);
        } else {
          res.status(400).json({error: 'Unknown Error', code: 400});
          console.error(
              `${req.method} ${res.statusCode} ${req.originalUrl} ${req.ip}`);
        }
      } else {
        next();
      }
    });

    this._app.use((req, res, next) => {
      res.set('Access-Control-Allow-Origin', '*');
      next();
      console.log(
          `${req.method} ${res.statusCode} ${req.originalUrl} ${req.ip}`);
    });
    this._app.post('/api/authenticate', (req, res) => {
      if (!req.body || !req.body.token) {
        res.status(403).json({error: 'Invalid or missing ID Token', code: 403});
        return;
      }
      const token = req.body.token;
      this._authenticator.verify(token, (err, decoded) => {
        if (err) {
          res.status(err.code || 403).json(err);
        } else {
          res.status(200).json(
              {message: `Successfully authenticated user: ${decoded.uid}`});
        }
      });
    });
    this._app.post('/api/update-data', (req, res) => {
      this._dataReceiver.handleData(req.body, (err) => {
        if (err) {
          res.status(err.code);
          res.json(err);
        } else {
          res.status(204);
          res.send();
        }
      });
    });
    this._app.post('/api/setup-device', (req, res) => {
      this._dataReceiver.handleSetupData(req.body, (err) => {
        if (err) {
          res.status(err.code);
          res.json(err);
        } else {
          res.status(204);
          res.send();
        }
      });
    });
    this._app.get('/api/get-data', (req, res) => {
      // Update cached data.
      if (this._dataServer.readyToReceiveData()) {
        this._dataReceiver.pushData(this._dataServer);
      }

      // Received potentially cached data.
      const data = this._dataServer.getData();
      if (data.code) {
        res.status(data.code);
      } else if (data.error) {
        res.status(500);
      } else {
        res.status(200);
      }
      res.json(data);
    });
    this._app.delete('/api/delete-device', (req, res) => {
      const data = this._dataReceiver.handleDeleteRequest(req.body, (err) => {
        if (err.code) {
          res.status(err.code);
        } else if (err.error) {
          res.status(500);
        } else {
          res.status(200);
        }
        res.json(err);
      });
    });
    this._app.use((req, res) => {
      res.status(404);
      res.json({
        error: 'Ha! You can\'t see that, because it doesn\'t exist!',
        code: 404,
      });
    });
  }
}

module.exports = Server;

// Author: Campbell Crowley (github@campbellcrowley.com).
// February, 2021
const express = require('express');
const DataServer = require('./DataServer.js');
const DataReceiver = require('./DataReceiver.js');

/**
 * Front-end server for user-request handling.
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
    this._dataReceiver = new DataReceiver();
  }
  /**
   * Start the server, and begin handling requests.
   * @public
   */
  run() {
    this._registerEndpoints();

    this._server = this._app.listen(this._port, () => {
      console.log(`Hello World! Server started on port ${this._port}`);
    });
  }
  /**
   * Stop the server, and prepare to be terminated.
   * @public
   */
  shutdown() {
    this._removeEndpoints();
    this._server.close();
  }
  /**
   * Register endpoint handlers with Express.
   * @private
   */
  _registerEndpoints() {
    this._app.post('/api/update-data', (req, res) => {
      // TODO: Parse req data.
      res.status(201);
      res.send();
    });
    this._app.get('/api/get-data', (req, res) => {
      res.status(200);
      res.send({data: this._dataServer.getData()});
    });
    this._app.use((req, res) => {
      res.status(404);
      res.send({error: 'Ha! You can\'t see that, because it doesn\'t exist!'});
    });
  }
  /**
   * Remove all endpoint handlers from Express.
   * @private
   */
  _removeEndpoints() {
  }
}

module.exports = Server;

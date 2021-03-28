// Author: Campbell Crowley (github@campbellcrowley.com).
// February, 2021
const ServeDataObject = require('./ServeDataObject.js');
const fs = require('fs');
const path = require('path');
const mkdirp = require('mkdirp');

const DeviceNoiseLevel = require('./DeviceNoiseLevel.js');
const DeviceLocation = require('./DeviceLocation.js');

// Directory to store each device config file.
const configPath = './data/configs/';
// Directory to store last received data value for each device.
const cachePath = './data/cache/';

/**
 * Parse and process data received from devices.
 * @class
 */
class DataReceiver {
  /**
   * Constructor.
   */
  constructor() {
    /**
     * Latest DeviceNoiseLevel info for each device, mapped by device ID.
     * @private
     * @type {Object.<DeviceNoiseLevel>}
     * @default
     * @constant
     */
    this._noiseLevels = {};

    /**
     * Map of device IDs to their location.
     * @private
     * @type {Object.<DeviceLocation>}
     * @default
     * @constant
     */
    this._sensorLocations = {};

    /**
     * To check if a user is an admin.
     * @TODO: Actually implement a valid way to authenticate users.
     * @private
     * @type {Object.<boolean>}
     * @constant
     * @default
     */
    this._administrators = {
      campbell: true,
      clayton: true,
      ryan: true,
      nate: true,
      austin: true,
    };

    this._loadAllData();
  }
  /**
   * Handle new data received from a device.
   * @public
   * @param {Object} data Data sent from a device.
   * @param {function} [cb] Callback once completed.
   */
  handleData(data, cb) {
    if (typeof cb !== 'function') cb = () => {};
    if (!data) {
      cb({error: 'Empty Request.', code: 400});
      return;
    }
    let volume = null;
    let id = null;
    if (data.id && data.volume) {
      id = data.id;
      volume = data.volume;
    } else {
      const split = data.toString().split(';');
      id = split[0];
      volume = split[1];

    if (!DeviceNoiseLevel.validate({id: id, volume: volume})) {
      cb({error: 'Invalid Data.', code: 400});
      return;
    }

    this._noiseLevels[id] = new DeviceNoiseLevel(id, volume, Date.now());
    this._saveData(id);
    }
  /**
   * Handle setup data received from an Admin.
   * @public
   * @param {Object} data Config data from app.
   * @param {function} [cb] Callback once completed.
   */
  handleSetupData(data, cb) {
    if (typeof cb !== 'function') cb = () => {};

    // Handle malformed requests.
    if (!data || typeof data !== 'object') {
      cb({error: 'Empty Request.', code: 400});
      return;
    } else if (!data.username) {
      cb({error: 'Forbidden. Not Authenticated.', code: 403});
      return;
    } else if (!this._administrators[data.username]) {
      cb({error: 'Forbidden. Unknown User.', code: 403});
      return;
    } else if (!data.id || !this._noiseLevels[data.id]) {
      cb({
        error: 'Unknown Device ID.',
        message: `Requested ID:"${data.id}" which could not be found.`,
        code: 400
      });
      return;
    } else if (!DeviceLocation.validate(data)) {
      cb({error: 'Invalid Data.', code: 400});
      return;
    }

    if (this._sensorLocations[data.id]) {
      this._sensorLocations[data.id].copy(data);
      cb({message: 'Updated Config.', code: 200});
    } else {
      this._sensorLocations[data.id] = new DeviceLocation(data);
      cb({message: 'Created Config.', code: 201});
    }

    this._saveConfig(data.id);
  }
  /**
   * Push data to our data server at periodic intervals.
   * @public
   * @param {DataServer} dataServer The data server instance to push our data
   *     into.
   */
  pushData(dataServer) {
    const obj = new ServeDataObject(this._noiseLevels, this._sensorLocations);
    dataServer.receiveData(obj);
  }

  /**
   * Load all cached data from disk into memory. This traverses the `cachePath`
   * directory and loads all discovered files. For each discovered file, the
   * correspoding config file will then additionally attempt to be loaded as
   * well.
   * @private
   */
  _loadAllData() {
    fs.readdir(cachePath, (err, list) => {
      if (err) {
        if (err.code !== 'ENOENT') {
          console.error(`Failed to read dir: ${cachePath}`);
          console.error(err);
        }
        return;
      }
      list.forEach((el) => {
        if (path.extname(el) !== '.json') return;
        const id = el.substr(0, el.length - 5);
        this._loadData(id, (err) => {
          if (err) return;
          this._loadConfig(id);
        });
      });
    });
  }

  /**
   * Save the config info of a device wwith the specified ID.
   * @private
   * @param {string} id Device ID.
   */
  _saveConfig(id) {
    const data = this._sensorLocations[id];
    const filename = `${configPath}${id}.json`;
    if (!data) {
      fs.unlink(filename, (err) => {
        if (!err || err.code === 'ENOENT') return;

        console.error(`Failed to unlink file ${filename}`);
        console.error(err);
      });
    } else {
      this._mkdirAndWrite(filename, JSON.stringify(data.serialize()));
    }
  }
  /**
   * Load a config into memory.
   * @private
   * @param {string} id Device ID.
   * @param {function} [cb] Callback once completed.
   */
  _loadConfig(id, cb) {
    if (typeof cb !== 'function') cb = () => {};

    const filename = `${configPath}${id}.json`;
    this._readFile(filename, (err, data) => {
      if (err) {
        cb(err);
        return;
      }
      let parsed;
      try {
        parsed = JSON.parse(data);
      } catch (err) {
        console.error(`Failed to parse file: ${filename}`);
        console.error(err);
        cb(err);
        return;
      }
      this._sensorLocations[id] = new DeviceLocation(parsed);
      cb(null, this._sensorLocations[id]);
    });
  }

  /**
   * Save stored data for a device.
   * @private
   * @param {string} id Device ID.
   */
  _saveData(id) {
    const data = this._noiseLevels[id];
    const filename = `${cachePath}${id}.json`;
    if (!data) {
      fs.unlink(filename, (err) => {
        if (!err || err.code === 'ENOENT') return;

        console.error(`Failed to unlink file ${filename}`);
        console.error(err);
      });
    } else {
      this._mkdirAndWrite(filename, JSON.stringify(data.serialize()));
    }
  }
  /**
   * Load stored data for a device.
   * @private
   * @param {string} id Device ID.
   * @param {function} [cb] Callback once completed.
   */
  _loadData(id, cb) {
    if (typeof cb !== 'function') cb = () => {};

    const filename = `${cachePath}${id}.json`;
    this._readFile(filename, (err, data) => {
      if (err) {
        cb(err);
        return;
      }
      let parsed;
      try {
        parsed = JSON.parse(data);
      } catch (err) {
        console.error(`Failed to parse file: ${filename}`);
        console.error(err);
        cb(err);
        return;
      }
      this._noiseLevels[id] = new DeviceNoiseLevel(parsed);
      cb(null, this._noiseLevels[id]);
    });
  }

  /**
   * Read a file.
   * @private
   * @param {string} filename File to read.
   * @param {function} cb Callback once completed.
   */
  _readFile(filename, cb) {
    fs.readFile(filename, (err, data) => {
      if (err && err.code !== 'ENOENT') {
        console.error(`Failed to read file: ${filename}`);
        console.error(err);
      }
      cb(err, data);
    });
  }

  /**
   * Write a file to disk, and create the parent directories if necessary.
   * @private
   * @param {string} filename Filename.
   * @param {*} data Data to write.
   * @param {function} [cb] Callback once completed.
   */
  _mkdirAndWrite(filename, data, cb) {
    if (typeof cb !== 'function') cb = () => {};
    const dir = path.dirname(filename);
    mkdirp(dir).then(() => {
      const tmpFile = `${filename}.tmp`;
      fs.writeFile(tmpFile, data, (err) => {
        if (err) {
          console.error(`Failed to write file: ${tmpFile}`);
          console.error(err);
          cb(err);
          return;
        }
        fs.rename(tmpFile, filename, (err) => {
          if (err) {
            console.error(`Failed to rename tmp file: ${tmpFile} --> ${filename}`);
            console.error(err);
            cb(err);
            return;
          }
          cb();  // Success.
        });
      });
    }).catch((err) => {
      if (err.code !== 'EEXIST') {
        console.error(`Failed to make directory: ${dir}`);
        console.error(err);
        cb(err);
      }
    });
  }
}

module.exports = DataReceiver;

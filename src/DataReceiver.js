// Author: Campbell Crowley (github@campbellcrowley.com).
// February, 2021
const ServeDataObject = require('./ServeDataObject.js');

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
  }
  /**
   * Handle new data received from a device.
   * @public
   * @param {string} uid Device ID with new data.
   * @param {number} volume Device measured volume level.
   */
  handleData(uid, volume) {
    this._noiseLevels[uid] = {
      uid: uid,
      volume: volume,
      timestamp: Date.now(),
    };
  }
  /**
   * Handle setup data received from an Admin.
   * @public
   * @param {Object} data Config data from app.
   * @param {function} [cb] Callback once completed.
   */
  handleSetupData(data, cb) {
    if (typeof cb === 'function') cb({error: 'Not yet implemented', code: 501});
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
}

module.exports = DataReceiver;

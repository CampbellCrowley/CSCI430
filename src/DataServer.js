// Author: Campbell Crowley (github@campbellcrowley.com).
// February, 2021
const ServeDataObject = require('./ServeDataObject.js');

// Time in milliseconds to cache data from DataReceiver.
const cacheTime = 5000;

/**
 * Back-end to prepare data for front-end requests.
 * @class
 */
class DataServer {
  /**
   * Constructor.
   */
  constructor() {
    /**
     * Latest noise levels from DataReceiver.
     * @private
     * @type {ServeDataObject}
     * @default
     * @constant
     */
    this._noiseLevels = new ServeDataObject();;
    /**
     * Timestamp at which data was last received from the DataReceiver.
     * @private
     * @type {number}
     * @default
     */
    this._lastReceiveTime = 0;
  }
  /**
   * A user has requested the noise level data.
   * @public
   * @returns {{error: ?string, data: ?object, code: ?number}} Data, or error
   *     message. Optional http status code may be supplied.
   */
  getData() {
    // return {error: 'Not Yet Implemented', code: 501};
    if (this._lastReceiveTime == 0) {
      return {error: 'No data received from sensors.', code: 500};
    } else if (this._noiseLevels.devices.length == 0) {
      return {error: 'No data sensors available.', code: 500};
    } else {
      return {data: this._noiseLevels.serialize(), code: 200};
    }
  }
  /**
   * New data has been received from DataReceiver.
   * @public
   * @param {ServeDataObject} data Received data.
   */
  receiveData(data) {
    this._noiseLevels = data;
    this._lastReceiveTime = Date.now();
  }
  /**
   * Are we ready to receive data. This will return true if the time since last
   * update has been long enough.
   * @public
   * @returns {boolean} True if data is stale, false if data is fresh.
   */
  readyToReceiveData() {
    return Date.now() - this._lastReceiveTime > cacheTime;
  }
}

module.exports = DataServer;

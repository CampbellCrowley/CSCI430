// Author: Campbell Crowley (github@campbellcrowley.com).
// February, 2021
const ServeDataObject = require('./ServeDataObject.js');
const DeviceNoiseLevel = require('./DeviceNoiseLevel.js');
const DeviceLocation = require('./DeviceLocation.js');

// Time in milliseconds to cache data from DataReceiver.
const cacheTime = 5000;

const exampleData = new ServeDataObject(
    {
      'ID0': new DeviceNoiseLevel(0, 1, Date.now()),
      'ID1': new DeviceNoiseLevel(1, 2, Date.now()),
    },
    {
      'ID0': new DeviceLocation(10.1, 15.1, 2, 1.0),
      'ID1': new DeviceLocation(15.1, 25.1, 2, 1.0),
    });

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
    this._noiseLevels = new ServeDataObject();
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
      return {
        error: 'No data received from sensors.',
        code: 500,
      };
    } else if (this._noiseLevels.devices.length == 0) {
      // return {error: 'No data sensors available.', code: 500};
      return {
        code: 200,
        message: 'Serving example data. No real device data available.',
        data: exampleData.serialize(),
      };
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

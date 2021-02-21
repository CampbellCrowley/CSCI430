// Author: Campbell Crowley (github@campbellcrowley.com).
// February, 2021

/**
 * @typedef LocationNoiseLevel
 * @property {DeviceLocation} location Location of sound info.
 * @property {number} volume Volume at location.
 */

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
     * @type {Object.<LocationNoiseLevel>}
     * @default
     * @constant
     */
    this._noiseLevels = {};
  }
  /**
   * A user has requested the noise level data.
   * @public
   */
  getData() {

  }
  /**
   * New data has been received from DataReceiver.
   * @public
   * @param {Object.<LocationNoiseLevel>} data Received data.
   */
  receiveData(data) {
    this._noiseLevels = data;
  }
}

module.exports = DataServer;

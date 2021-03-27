// Author: Campbell Crowley (github@campbellcrowley.com).
// February, 2021

/**
 * @classdesc Structed data to serve to clients.
 * @class
 */
class ServeDataObject {
  /**
   * Import and format the appropriate data into the form clients will expect.
   * @param {Object.<DeviceNoiseLevel>} noiseLevels Object of known noise levels
   *     for each device.
   * @param {Object.<DeviceLocation>} sensorLocations The location information
   *     for each device.
   */
  constructor(noiseLevels = {}, sensorLocations = {}) {
    /**
     * Array of devices with their associated information and data.
     * @public
     * @constant
     * @type {Array.<{id: string, name: string, level: DeviceNoiseLevel,
     *     location: DeviceLocation}>}
     */
    this.devices = Object.entries(noiseLevels).map((el) => {
      return {
        id: el[0],
        name: `Device ${el[0]}`,
        level: el[1],
        location: sensorLocations[el[0]],
      };
    });
    /**
     * Timestamp of last modified time.
     * @public
     * @constant
     * @type {number}
     */
    this.timestamp = Date.now();
  }
  /**
   * Create serializable object from the data.
   * @returns {{devices: Array, timestamp: number}} Our contained data in
   *     serializable format.
   */
  serialize() {
    return {
      devices: this.devices,
      timestamp: Date.now(),
    };
  }
}
module.exports = ServeDataObject;

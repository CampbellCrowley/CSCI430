// Author: Campbell Crowley (github@campbellcrowley.com).
// March, 2021

/**
 * Corresponds to a single device location. This may be a coordinate system
 * relative to a single building, where the altitude is the floor.
 * @class
 */
class DeviceLocation {
  /**
   * Create location instance.
   * @param {number|DeviceLocation} lat Latitude (Y), or another instance to
   *     copy.
   * @param {number} lon Longitude (X).
   * @param {number} alt Altitude (May correlate to building floor).
   * @param {number} accuracy Accuracy in meters.
   * @param {string} [name] Name of the device.
   */
  constructor(lat, lon, alt, accuracy, name) {
    let obj = null;
    if (lat && Number.isNaN(lat * 1)) {
      obj = lat;
      lat = null;
    }

    /**
     * Device latitude (Y).
     * @public
     * @type {?number}
     */
    this.lat = lat ?? null;
    /**
     * Device longitude (X).
     * @public
     * @type {?number}
     */
    this.lon = lon ?? null;
    /**
     * Device altitude (floor).
     * @public
     * @type {?number}
     */
    this.alt = alt ?? null;
    /**
     * Device location accuracy (unknown units).
     * @public
     * @type {?number}
     */
    this.accuracy = accuracy ?? null;
    /**
     * User-friendly name of the device.
     * @public
     * @type {?string}
     */
    this.name = name ?? null;

    if (obj) this.copy(obj);
  }
  /**
   * Validate an object data values. If all given values can be coerced to valid
   * values, this will return true. False if at least one given value cannot be
   * coerced properly.
   * @public
   * @static
   * @param {DeviceLocation} obj DeviceLocation-like object to validate.
   * @returns {boolean} True if completely valid, false otherwise.
   */
  static validate(obj) {
    if (obj.x || obj.lon) {
      const num = (obj.lon ?? obj.x) * 1;
      if (Number.isNaN(num)) return false;
    }
    if (obj.y || obj.lat) {
      const num = (obj.lat ?? obj.y) * 1;
      if (Number.isNaN(num)) return false;
    }
    if (obj.floor || obj.alt) {
      const num = (obj.alt ?? obj.floor) * 1;
      if (Number.isNaN(num)) return false;
    }
    if (obj.accuracy) {
      const num = obj.accuracy * 1;
      if (Number.isNaN(num)) return false;
    }
    if (obj.name) {
      if (typeof obj.name !== 'string') return false;
      if (obj.name.length > 100) return false;
    }
    return true;
  }
  /**
   * Copy values from another instance. Existing values that are not overriden
   * will be kept.
   * @public
   * @param {DeviceLocation} obj Object to copy values from.
   * @returns {boolean} Error, true if a supplied value failed to be copied.
   */
  copy(obj) {
    if (!obj) return false;
    let error = false;
    if (obj.x || obj.lon) {
      const num = (obj.lon ?? obj.x) * 1;
      if (!Number.isNaN(num)) this.lon = num;
      else error = true;
    }
    if (obj.y || obj.lat) {
      const num = (obj.lat ?? obj.y) * 1;
      if (!Number.isNaN(num)) this.lat = num;
      else error = true;
    }
    if (obj.floor || obj.alt) {
      const num = (obj.alt ?? obj.floor) * 1;
      if (!Number.isNaN(num)) this.alt = num;
      else error = true;
    }
    if (obj.accuracy) {
      const num = obj.accuracy * 1;
      if (!Number.isNaN(num)) this.accuracy = num;
      else error = true;
    }
    if (obj.name) this.name = obj.name;

    return error;
  }
  /**
   * Get serializable format.
   * @returns {{lat: ?number, lon: ?number, alt: ?number, accuracy: ?number,
   *     name : ?string}} Stored data.
   */
  serialize() {
    return {
      lat: this.lat,
      lon: this.lon,
      alt: this.alt,
      accuracy: this.accuracy,
      name: this.name,
    };
  }
}
module.exports = DeviceLocation;

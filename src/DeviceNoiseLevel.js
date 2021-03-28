// Author: Campbell Crowley (github@campbellcrowley.com).
// March, 2021

/**
 * Corresponds to a single device sound level info.
 * @class
 */
class DeviceNoiseLevel {
  /**
   * Create new DeviceNoiseLevel object.
   * @param {string|DeviceNoiseLevel} [id=null] Device unique ID, or instance to
   *     copy.
   * @param {number} [volume=null] Device measured volume level.
   * @param {number} [timestamp=0] Timestamp of measured time.
   */
  constructor(id, volume, timestamp) {
    let obj = null;
    if (id && typeof id === 'object') {
      obj = id;
      id = null;
    }
    this.id = id ?? null;
    this.volume = volume ?? null;
    this.timestamp = timestamp ?? 0;

    if (obj) this.copy(obj);
  }
  /**
   * Validate an object data values. If all given values can be coerced to valid
   * values, this will return true. False if at least one given value cannot be
   * coerced properly.
   * @public
   * @static
   * @param {DeviceNoiseLevel} obj DeviceNoiseLevel-like object to validate.
   * @returns {boolean} True if completely valid, false otherwise.
   */
  static validate(obj) {
    if (obj.volume) {
      const num = obj.volume * 1;
      if (Number.isNaN(num)) return false;
    }
    if (obj.timestamp) {
      const num = obj.timestamp * 1;
      if (Number.isNaN(num)) return false;
      if (num < 0) return false;
    }
    if (obj.id) {
      if (typeof obj.id !== 'string') return false;
      if (obj.id.length > 100) return false;
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
    if (obj.volume) {
      const num = obj.volume * 1;
      if (!Number.isNaN(num)) this.volume = num;
      else error = true;
    }
    if (obj.timestamp) {
      const num = obj.timestamp * 1;
      if (!Number.isNaN(num) && num >= 0) {
        this.timestamp = num;
      } else {
        error = true;
      }
    }
    if (obj.id) this.id = obj.id;

    return error;
  }
  /**
   * Get serializable format.
   * @returns {{id: ?string, volume: ?string, timestamp: number}} Stored data.
   */
  serialize() {
    return {
      id: this.id,
      volume: this.volume,
      timestamp: this.timestamp,
    };
  }
}
module.exports = DeviceNoiseLevel;

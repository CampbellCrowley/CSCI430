// Author: Campbell Crowley (github@campbellcrowley.com).
// March, 2021

/**
 * Corresponds to a single device sound level info.
 * @class
 */
class DeviceNoiseLevel {
  /**
   * Create new DeviceNoiseLevel object.
   * @param {string} [id=null] Device unique ID.
   * @param {number} [volume=null] Device measured volume level.
   * @param {number} [timestamp=0] Timestamp of measured time.
   */
  constructor(id, volume, timestamp) {
    this.id = id ?? null;
    this.volume = volume ?? null;
    this.timestamp = timestamp ?? 0;
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

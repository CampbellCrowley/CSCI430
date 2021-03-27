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
   * @property {number} lat Latitude.
   * @property {number} lon Longitude.
   * @property {number} alt Altitude (May correlate to building floor).
   * @property {number} accuracy Accuracy in meters.
   */
  constructor(lat, lon, alt, accuracy) {
    this.lat = lat ?? null;
    this.lon = lon ?? null;
    this.alt = alt ?? null;
    this.accuracy = accuracy ?? null;
  }
  /**
   * Get serializable format.
   * @returns {{lat: ?number, lon: ?number, alt: ?number, accuracy: ?number}}
   *     Stored data.
   */
  serialize() {
    return {
      lat: this.lat,
      lon: this.lon,
      alt: this.alt,
      accuracy: this.accuracy,
    };
  }
}
module.exports = DeviceLocation;

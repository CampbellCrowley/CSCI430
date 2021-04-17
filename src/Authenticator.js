// Author: Campbell Crowley (github@campbellcrowley.com).
// February, 2021
const admin = require('firebase-admin');
const serviceAccount =
    require('../config/hushadmin-firebase-adminsdk-ntipm-a10b3bbb0d.json');
const adminsList = require('../config/admins.json');

/**
 * Manages authenticating admins via Firebase.
 * @class
 */
class Authenticator {
  constructor() {
    admin.initializeApp({
      credential: admin.credential.cert(serviceAccount),
    });
  }

  /**
   * Verify an ID token from the app.
   * @public
   * @param {string} token Token to verify.
   * @param {function} cb Callback once verified or failed. Contains decoded
   *     info if succeeded.
   */
  verify(token, cb) {
    if (typeof cb !== 'function') {
      throw new TypeError('cb must be a callback function');
    }
    admin.auth()
        .verifyIdToken(token)
        .then((decodedToken) => {
          console.log(
              `Authenticated: ${decodedToken.uid} ${decodedToken.name}`);
          cb(null, decodedToken)
        })
        .catch((error) => {
          console.error(`Failed to validate token: ${token}`);
          console.error(error);
          cb({error: 'Failed to verify ID Token', code: 403}, error);
        });
  }
  /**
   * Check if a given User ID is an administrator.
   * @public
   * @param {string} uid User ID to check.
   * @param {function} cb Callback with results.
   */
  isAdmin(uid, cb) {
    if (adminsList[uid] !== undefined) {
      cb(null, true);
    } else {
      cb(null, false);
    }
  }
}

module.exports = Authenticator;

// Author: Campbell Crowley (github@campbellcrowley.com).
// February, 2021
const Server = require('./src/Server.js');

if (require.main === module) {
  // If run from CLI...
  const host = {
    port: process.argv[2],
    address: process.argv[3],
  };

  console.log(
      'Attempting to start server with args: ' + process.argv.slice(2, 3));

  const server = new Server(host);
  server.run();

  process.on('SIGINT', () => {
    console.log('Caught SIGINT, shutting down...');
    server.shutdown();
  });
} else {
  // Else required by other module...
  module.exports = Server;
}

const HDWalletProvider = require("@truffle/hdwallet-provider");

// Temporary - taken from FlightSurety App
var mnemonic = "candy maple cake sugar pudding cream honey rich smooth crumble sweet treat";

module.exports = {
  networks: {
     development: {
      host: "127.0.0.1",
      port: 8545,
      network_id: "*",
     },
  },

  // Configure compilers
  compilers: {
    solc: {      
      version: "0.8.15"
    }
  }
}

const HDWalletProvider = require("@truffle/hdwallet-provider");

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

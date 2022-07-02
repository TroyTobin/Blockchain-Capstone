// migrating the appropriate contracts
var SquareVerifier = artifacts.require("./SquareVerifier.sol");
var SolnSquareVerifier = artifacts.require("./SolnSquareVerifier.sol");

module.exports = function(deployer) {
  deployer.deploy(SquareVerifier).then(function(verifierInstance) {
    return deployer.deploy(SolnSquareVerifier, verifierInstance.address).then(function(SolnSquareVerifierInstance) {
      console.log(verifierInstance.address, SolnSquareVerifierInstance.address);
    })
  });
};

const _GavinBookStore = artifacts.require("GavinBookStore");

module.exports = function (deployer) {
  deployer.deploy(_GavinBookStore);
};

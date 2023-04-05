const { network } = require("hardhat");
const { networkConfig } = require("../helper-hardhat-config");
const { developmentChains } = require("../helper-hardhat-config");
const { verify } = require("../utils/verify");
module.exports = async (hre) => {
  const { getNamedAccounts, deployments } = hre;
  const { deployer } = await getNamedAccounts();
  const { deploy, log } = deployments;
  const chainId = network.config.chainId;
  let threshold = networkConfig[chainId]["threshold"];
  let profitthreshold = networkConfig[chainId]["profitthreshold"];
  let target = networkConfig[chainId]["target"];

  const args = [target, threshold, profitthreshold];
  console.log("Deploying");
  const crowdFunding = await deploy("crowdfunding", {
    from: deployer,
    args: [target, threshold, profitthreshold],
    log: true,
    // waitConfirmations: network.name.blockConfirmations || 1,
  });
  if (!developmentChains.includes(network.name)) {
    await verify(crowdFunding.address, args);
  }
  console.log("deployed");
};
module.exports.tags = ["all"];

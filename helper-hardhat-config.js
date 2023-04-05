const networkConfig = {
  31337: {
    name: "localhost",
    target: 100000000,
    threshold: 100000000000,
    profitthreshold: 100000000000000,
  },
  // Price Feed Address, values can be obtained at https://docs.chain.link/docs/reference-contracts
  5: {
    name: "goerli",
    ethUsdPriceFeed: "0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e",
    target: 100000000,
    threshold: 100000000000,
    profitthreshold: 100000000000000,
  },
};
const developmentChains = ["hardhat"];

module.exports = {
  networkConfig,
  developmentChains,
};

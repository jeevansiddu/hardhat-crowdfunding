const { getNamedAccounts, ethers } = require("hardhat");
const { deployments } = require("hardhat");
async function main() {
  const { deployer } = await getNamedAccounts();
  await deployments.fixture(["all"]);

  const crowdFunding = await ethers.getContract("crowdfunding", deployer);
  console.log("Funding Contract");
  const transactionresponse = await crowdFunding.fund({
    value: 10000000000000,
  });
  const transactionreceipt = await transactionresponse.wait(1);
  console.log("Funded");
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });

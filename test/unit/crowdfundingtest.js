const { assert, expect } = require("chai");
const { network, deployments, ethers } = require("hardhat");
const { developmentChains } = require("../../helper-hardhat-config");

describe("crowdfunding", function () {
  let deployer;
  let crowdFunding;
  beforeEach(async () => {
    deployer = (await getNamedAccounts()).deployer;
    await deployments.fixture(["all"]);
    crowdFunding = await ethers.getContract("crowdfunding", deployer);
  });
  describe("constructor", async function () {
    it("checks for target is more than threshold", async function () {
      let k = crowdFunding.target;

      assert.equal(k.toString(), k.toString());
    });
  });
  describe("fund", async function () {
    it("it fails when you dont send enough money", async function () {
      await expect(crowdFunding.fund({ value: 1000000000000 })).to.be.reverted;
    });
    it("updates the value of total fund raised", async function () {
      let startingbalance = await ethers.provider.getBalance(deployer);
      let transactionresponse = await crowdFunding.fund({
        value: 10000000000000,
      });
      let transactionreceipt = await transactionresponse.wait(1);
      const { gasUsed, effectiveGasPrice } = transactionreceipt;
      const gascost = gasUsed.mul(effectiveGasPrice);
      let endingbalance = await ethers.provider.getBalance(deployer);
      assert.equal(
        endingbalance.add(10000000000000).add(gascost).toString(),
        startingbalance.toString()
      );
    });
  });
});

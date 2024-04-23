import { ethers } from "hardhat";

describe("Getting Init code hash", function () {
  it("init", async () => {
    const InitiCodeHash = await ethers.getContractFactory("InitiCodeHash");
    const codehashCon = await InitiCodeHash.deploy()
    const codehash = await codehashCon.getInitHash();
    console.log(codehash)
  })
})
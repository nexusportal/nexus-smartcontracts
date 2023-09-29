import { ethers } from 'hardhat';
import { admin } from './var';

async function main() {

  const CalHash = await ethers.getContractFactory("CalHash");
  const calHash = await CalHash.deploy();
  const res = await calHash.getInitHash();
  console.log("calhash = ", calHash.address)
  console.log("hash: ", res)

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
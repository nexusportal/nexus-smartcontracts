import { ethers } from 'hardhat';
import { admin, NexusToken } from './var';

async function main() {
  const WETH9 = await ethers.getContractFactory('WETH9');
  const wETH9 = await WETH9.deploy();
  await wETH9.deployed();
  console.log('const weh9 = "', wETH9.address, '"');

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

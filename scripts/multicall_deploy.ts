import { ethers } from 'hardhat';
import { WETH9, admin, NexusToken } from './var';

async function main() {
  const Multicall2 = await ethers.getContractFactory('Multicall2');
  const multicall2 = await Multicall2.deploy();
  await multicall2.deployed();
  console.log('const multicall = "', multicall2.address, '"');

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

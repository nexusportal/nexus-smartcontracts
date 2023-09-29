import { ethers } from 'hardhat';
import abi from "../artifacts/contracts/NexusGenerator.sol";

async function main() {
  const contract = new ethers.Contract( , ABI, trybSenderWallet);

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

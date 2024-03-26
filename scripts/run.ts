import { ethers } from 'hardhat';
import * as dotenv from "dotenv";
import { parseEther } from 'ethers/lib/utils';
import { NexusToken, multiStakingDistributor, nexusNFT, nexusWeight } from './apothem/apothem_var';

dotenv.config();
const pk = process.env.PK ?? "";
const RPCURL = "https://erpc.apothem.network";

async function main() {
  const provider = new ethers.providers.JsonRpcProvider(RPCURL);
  const trybSenderWallet = new ethers.Wallet(pk, provider)
  const multiStaking = await ethers.deployContract("NexusNFTMultiStaking", [NexusToken, nexusNFT, nexusWeight]);
  await multiStaking.deployed();
  console.log("multistaking address: ", multiStaking.address);
  await multiStaking.setDistributor(multiStakingDistributor)

  // const factorycontract = new ethers.Contract(factory, factoryABI, trybSenderWallet);
  // const superfarmcontract = new ethers.Contract(superfarm, superABI, trybSenderWallet);
  // await superfarmcontract.add(alloc, element, false);
  // await superfarmcontract.setRewardToken(element, EARTH, 1);
  // await superfarmcontract.setRewardToken(element, AIR, 1);
  // await superfarmcontract.setRewardToken(element, FIRE, 1);
  // await superfarmcontract.setRewardToken(element, SPACE, 1);
  // await superfarmcontract.setRewardToken(element, WATER, 1); 
}
// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

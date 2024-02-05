import { ethers } from 'hardhat';
import * as dotenv from "dotenv";
import { parseEther } from 'ethers/lib/utils';

dotenv.config();
const pk = process.env.PK ?? "";
const RPCURL = "https://erpc.apothem.network";

async function main() {
   // console.log("NEXU / WAN:", await factorycontract.getPair(NexusToken, WAN))
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

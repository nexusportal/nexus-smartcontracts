import { ethers } from 'hardhat';
import * as dotenv from "dotenv";
import { parseEther } from 'ethers/lib/utils';
import { deployContract } from '../utils';

dotenv.config();
const pk = process.env.PK ?? "";
const RPCURL = process.env.RPCURL;

async function main() {
    const provider = new ethers.providers.JsonRpcProvider(RPCURL);
    const trybSenderWallet = new ethers.Wallet(pk, provider)
    const test = await deployContract("Test", ["TestName"], "NexusSwap");
}
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
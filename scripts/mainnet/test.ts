import * as dotenv from "dotenv";
import { deployContract } from '../utils';
import { ethers } from "hardhat";

dotenv.config();

async function main() {
    const factory = await ethers.deployContract("Test", [])
    const contract = await factory.deployed()
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
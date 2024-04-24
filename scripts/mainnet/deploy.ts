import { ethers } from 'hardhat';
import * as dotenv from "dotenv";
import { parseEther } from 'ethers/lib/utils';
import { deployContract } from '../utils';

dotenv.config();
// -----------------------
const newOwnerAddress = "0xD244e2E0b6E90124b6b59401b06B2CF15aaC78E5"
const feeToSetter = "0xD244e2E0b6E90124b6b59401b06B2CF15aaC78E5"
const WETH = "0x951857744785e80e2de051c32ee7b25f9c458c42"
const NexusNFT = "0x5272caeb01711af57a119a53be1b863cde8178bd"
const NexusWeight = "0x8DdD0FD4c84bf3FDb2A14CF98fAA48D0f82f4caF"
const nexusPerBlock = parseEther("0");
const startBlock = 0
const bonusEndBlock = 0
const distAmountInDistributeNexus = parseEther("0")
const timeIntervalInDistributeNexus = 3600 * 24 // a day
//------------------------


async function main() {
    // const test = await deployContract("Test", ["TestName"], "NexusSwap");
    const factory = await deployContract("NexusFactory", [feeToSetter], "NexusSwap")
    const router = await deployContract("NexusRouter", [factory.address, WETH], "")
    const NexusToken = await deployContract("NexusToken", [], "")
    const distributeNexus = await deployContract("DistributeNexus", [], "")
    const nexusDiffuser = await deployContract("NexusDiffuser", [factory.address, NexusToken.address, WETH], "")
    // const nexusWeight = await deployContract("NexusNFTWeight", [], "")
    const nexusNFTMultiStaking = await deployContract("NexusNFTMultiStaking", [NexusToken.address, NexusNFT, NexusWeight], "")
    const multiStakingDistributor = await deployContract("NexusNFTMultiStakingDistributor", [nexusNFTMultiStaking.address], "")
    const nexusGenerator = await deployContract("NexusGenerator", [NexusToken.address, multiStakingDistributor.address, nexusPerBlock, startBlock, bonusEndBlock], "")

    await distributeNexus.contract.setnexusToken(NexusToken.address)
    await distributeNexus.contract.setMultiStaking(nexusNFTMultiStaking.address)
    await distributeNexus.contract.setDistAmount(distAmountInDistributeNexus)
    await distributeNexus.contract.setTimeInterval(timeIntervalInDistributeNexus)

    await NexusToken.contract.transferOwnership(newOwnerAddress)
    await distributeNexus.contract.transferOwnership(newOwnerAddress)
    await nexusDiffuser.contract.setNexusTreasurySetter(newOwnerAddress)
    await nexusDiffuser.contract.transferOwnership(newOwnerAddress)
    await nexusNFTMultiStaking.contract.transferOwnership(newOwnerAddress)
    await multiStakingDistributor.contract.transferOwnership(newOwnerAddress)
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
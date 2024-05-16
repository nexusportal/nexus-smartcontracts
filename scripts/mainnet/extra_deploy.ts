import * as dotenv from "dotenv";
import { deployContract } from '../utils';
import { parseEther } from "ethers/lib/utils";

dotenv.config();

const nexusTokenaddress = "0x6DaF228391e388B05BBc682FEA3CB1Cc3E38c44E"
const multiStakingDistributor = "0xa96d4Dfb9EED8824cae29fA0b7e62c72b5e51018";
const nexusPerBlock = parseEther("0");
const startBlock = 0
const bonusEndBlock = 0


async function main() {
    // await deployContract("Multicall2", [], "Mocks");
    const nexusGenerator = await deployContract("NexusGenerator", [nexusTokenaddress, multiStakingDistributor, nexusPerBlock, startBlock, bonusEndBlock], "")
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
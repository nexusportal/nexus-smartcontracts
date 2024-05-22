import * as dotenv from "dotenv";
import { deployContract } from '../utils';
import { formatEther, parseEther, parseUnits } from "ethers/lib/utils";
import { ethers, Wallet } from "ethers";
import { NexuGenABI } from "../../abis/NexuGen";

dotenv.config();

const oldNexuGen = "0x8Ad2D1A537fe16d1C619fD877a26FA584798107f"
const newNexuGen = "0xCfC6B24a242171Dec6ec80d205871e4E76c8f8cF"


async function main() {
    const provider = new ethers.providers.JsonRpcProvider(process.env.MAIN_RPCURL);
    const signer = new Wallet(process.env.PK || "", provider);
    let signerNonce = await signer.getTransactionCount()
    const oldNexuGenContract = new ethers.Contract(oldNexuGen, NexuGenABI, signer);
    const newNexuGenContract = new ethers.Contract(newNexuGen, NexuGenABI, signer);
    const oldPoolLength = await oldNexuGenContract.poolLength();
    console.log("poolLength:", oldPoolLength.toNumber(), signerNonce)
    for (let i = 0; i < oldPoolLength; i++) {
        try {
            console.log("------------------------");
            const poolInfo = await oldNexuGenContract.getPoolInfo(i);
            console.log("poolInfo:", poolInfo.allocPoint.toNumber(), poolInfo.lpToken)
            let tx = await newNexuGenContract.add(poolInfo.allocPoint.toNumber(), poolInfo.lpToken, false, {
                gasLimit: 8000000,
                nonce: signerNonce++
            })
            await tx.wait();
            console.log("addPool:", i, poolInfo.lpToken, signerNonce)            
            const rewardTokens = await oldNexuGenContract.getRewardTokenInfo(i);
            const rewardLength = rewardTokens.length;
            for (let j = 0; j < rewardLength; j++) {
                const rewardTokenInfo = rewardTokens[j];
                const distRate = formatEther(rewardTokenInfo.distRate)
                tx = await newNexuGenContract.setRewardToken(
                    poolInfo.lpToken,
                    rewardTokenInfo.rewardToken,
                    parseEther(distRate),
                    {
                        gasLimit: 8000000,
                        nonce: signerNonce++
                    }
                )
                await tx.wait();
                console.log("setRewardToken:", i, j, rewardTokenInfo.rewardToken, signerNonce)
            }
        } catch (error) {
            console.log(error)
            continue;
        }
    }
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
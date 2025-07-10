import { ethers } from 'hardhat';
import * as dotenv from "dotenv";
import { parseEther } from 'ethers/lib/utils';

dotenv.config();

// -----------------------
// CONTRACT & LP CONFIGURATION
// -----------------------
const ROUTER_ADDRESS = "0x466E71a43B68928a3f5A3056Ce930C3e50518141"; // FIXED NexusRouterXRP
const TEST_TOKEN_ADDRESS = "0x9e0C30ee6519f715b337F1211eeC69d32A7E3915";

const XRP_AMOUNT = parseEther("1");       // 1 XRP
const TEST_TOKEN_AMOUNT = parseEther("1000"); // 1000 TEST
//------------------------

async function main() {
    console.log("🚀 Starting Liquidity Provision Script...");
    console.log("📍 Network: XRP EVM Mainnet");
    console.log(`💧 Adding ${ethers.utils.formatEther(XRP_AMOUNT)} XRP and ${ethers.utils.formatEther(TEST_TOKEN_AMOUNT)} TEST`);
    console.log("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");

    // Get contract instances and signer
    const router = await ethers.getContractAt("NexusRouterXRP", ROUTER_ADDRESS);
    const testToken = await ethers.getContractAt("TestToken", TEST_TOKEN_ADDRESS);
    const [deployer] = await ethers.getSigners();

    console.log("👤 Liquidity Provider:", deployer.address);
    console.log("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");

    // --- Step 1: Approve Router to spend TestToken ---
    console.log("1️⃣ Approving router to spend TestToken...");
    const approveTx = await testToken.approve(ROUTER_ADDRESS, TEST_TOKEN_AMOUNT);
    console.log("   Approval Transaction Hash:", approveTx.hash);
    await approveTx.wait();
    console.log("   ✅ Router approved successfully!");
    console.log("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
    
    // --- Step 2: Add Liquidity ---
    console.log("2️⃣ Adding liquidity to the pool...");
    
    // Set a deadline 10 minutes from now
    const deadline = Math.floor(Date.now() / 1000) + 60 * 10;
    
    const addLpTx = await router.addLiquidityETH(
        TEST_TOKEN_ADDRESS,     // address of the token
        TEST_TOKEN_AMOUNT,      // amount of token desired
        TEST_TOKEN_AMOUNT.sub(TEST_TOKEN_AMOUNT.div(100)), // minimum amount of token (1% slippage)
        XRP_AMOUNT.sub(XRP_AMOUNT.div(100)), // minimum amount of ETH (1% slippage)
        deployer.address,       // address to send LP tokens to
        deadline,               // deadline for the transaction
        { value: XRP_AMOUNT }   // amount of XRP to send
    );

    console.log("   Add Liquidity Transaction Hash:", addLpTx.hash);
    await addLpTx.wait();
    console.log("   ✅ Liquidity added successfully!");
    console.log("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");

    // --- Step 3: Verify LP Tokens ---
    console.log("3️⃣ Verifying LP token balance...");
    const factoryAddress = await router.factory();
    const factoryContract = await ethers.getContractAt("INexusSwapFactory", factoryAddress);
    const wethAddress = await router.WETH();
    const pairAddress = await factoryContract.getPair(TEST_TOKEN_ADDRESS, wethAddress);

    const pairContract = await ethers.getContractAt("INexusSwapPair", pairAddress);
    const lpTokenBalance = await pairContract.balanceOf(deployer.address);

    console.log("   💎 LP Token Address (Pair):", pairAddress);
    console.log("   💰 Your LP Token Balance:", ethers.utils.formatEther(lpTokenBalance));

    if (lpTokenBalance.gt(0)) {
        console.log("🎉 SUCCESS! You have successfully created a new liquidity pool and received LP tokens.");
    } else {
        console.log("❌ ERROR: LP tokens were not minted. Please check the transaction on the explorer.");
    }
    console.log("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
}

main().catch((error) => {
    console.error("❌ Script failed:", error);
    process.exitCode = 1;
}); 
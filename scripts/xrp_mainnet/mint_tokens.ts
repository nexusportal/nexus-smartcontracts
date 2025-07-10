import { ethers } from 'hardhat';
import * as dotenv from "dotenv";
import { parseEther } from 'ethers/lib/utils';

dotenv.config();

// -----------------------
// DEPLOYED CONTRACT & RECIPIENT ADDRESS
// -----------------------
const TEST_TOKEN_ADDRESS = "0x9e0C30ee6519f715b337F1211eeC69d32A7E3915";
const RECIPIENT_ADDRESS = "0x8d6Be820bEd89A134FaE82D4DE68b6a75a2Fa163";
const MINT_AMOUNT = parseEther("1000000"); // 1 Million TestTokens
//------------------------

async function main() {
    console.log("🚀 Starting TestToken Minting Process...");
    console.log("📍 Network: XRP EVM Mainnet");
    console.log("🎯 Recipient Address:", RECIPIENT_ADDRESS);
    console.log("💰 Amount to Mint:", ethers.utils.formatEther(MINT_AMOUNT), "TEST");
    console.log("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");

    // Get contract instance
    const testToken = await ethers.getContractAt("TestToken", TEST_TOKEN_ADDRESS);
    const [deployer] = await ethers.getSigners();

    console.log("👤 Minter Address (from PK):", deployer.address);
    console.log("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");

    // Check pre-mint balance
    const balanceBefore = await testToken.balanceOf(RECIPIENT_ADDRESS);
    console.log("📊 Balance Before Mint:", ethers.utils.formatEther(balanceBefore), "TEST");

    // Mint the tokens
    console.log("🔧 Minting 1,000,000 TestTokens...");
    const tx = await testToken.mint(RECIPIENT_ADDRESS, MINT_AMOUNT);
    console.log("⛓️ Transaction Hash:", tx.hash);
    
    // Wait for the transaction to be confirmed
    await tx.wait();
    console.log("✅ Transaction Confirmed!");

    // Check post-mint balance
    const balanceAfter = await testToken.balanceOf(RECIPIENT_ADDRESS);
    console.log("📊 Balance After Mint:", ethers.utils.formatEther(balanceAfter), "TEST");
    console.log("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");

    // Final verification
    const expectedBalance = balanceBefore.add(MINT_AMOUNT);
    if (balanceAfter.eq(expectedBalance)) {
        console.log("🎉 SUCCESS! 1,000,000 TestTokens were successfully minted to the address.");
    } else {
        console.log("❌ ERROR: Balance mismatch after minting. Please check the transaction on the explorer.");
    }
    console.log("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
}

main().catch((error) => {
    console.error("❌ Minting script failed:", error);
    process.exitCode = 1;
}); 
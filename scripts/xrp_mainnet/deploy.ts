import { ethers } from 'hardhat';
import * as dotenv from "dotenv";
import { parseEther } from 'ethers/lib/utils';
import { deployContract } from '../utils';

dotenv.config();

// -----------------------
// XRP EVM MAINNET CONFIGURATION
// -----------------------
const newOwnerAddress = "0x8d6Be820bEd89A134FaE82D4DE68b6a75a2Fa163" // Your provided owner address
const feeToSetter = "0x8d6Be820bEd89A134FaE82D4DE68b6a75a2Fa163" // Same as owner for initial setup
const WXRP = "0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE" // XRP EVM WXRP contract
const multiStakingDistributor = "0x8d6Be820bEd89A134FaE82D4DE68b6a75a2Fa163" // Using owner address as distributor
const nexusPerBlock = parseEther("0") // 0 NEXUS tokens per block - as you specified
const startBlock = 0 // Will be set to current block during deployment
const bonusEndBlock = 0 // No bonus period initially
//------------------------

async function verifyInitCodeHash() {
    console.log("🔍 Verifying Init Code Hash...");
    
    // Get the actual hash from NexusSwapPair bytecode
    const NexusSwapPair = await ethers.getContractFactory("NexusSwapPair");
    const actualHash = ethers.utils.keccak256(NexusSwapPair.bytecode);
    
    console.log("📋 Actual NexusSwapPair Hash:", actualHash);
    console.log("⚠️  Please verify this matches the hash in NexusSwapLibrary.sol");
    console.log("⚠️  If not, update the library before deployment!");
    
    return actualHash;
}

async function main() {
    console.log("🚀 Starting XRP EVM Mainnet Deployment (Simplified)...");
    console.log("📍 Network: XRP EVM Mainnet");
    console.log("👤 Owner Address:", newOwnerAddress);
    console.log("💧 WXRP Address:", WXRP);
    console.log("⛽ Fee Setter:", feeToSetter);
    console.log("🎯 Multi Staking Distributor:", multiStakingDistributor);
    console.log("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");

    // Verify init code hash before deployment
    await verifyInitCodeHash();
    console.log("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");

    // Get current block number for startBlock
    const currentBlock = await ethers.provider.getBlockNumber();
    const actualStartBlock = currentBlock + 100; // Start rewards 100 blocks from now
    
    console.log("📦 Current Block:", currentBlock);
    console.log("🎯 Start Block:", actualStartBlock);
    console.log("⚡ Nexus Per Block:", nexusPerBlock.toString());
    console.log("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");

    // 1. Deploy Core Contracts
    console.log("1️⃣ Deploying Core DEX Contracts...");
    
    const factory = await deployContract("NexusFactory", [feeToSetter], "NexusSwap");
    console.log("✅ NexusFactory deployed:", factory.address);
    
    const router = await deployContract("NexusRouter", [factory.address, WXRP], "");
    console.log("✅ NexusRouter deployed:", router.address);
    
    console.log("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");

    // 2. Deploy TestToken
    console.log("2️⃣ Deploying TestToken...");
    
    const TestToken = await deployContract("TestToken", [], "");
    console.log("✅ TestToken deployed:", TestToken.address);
    
    console.log("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");

    // 3. Deploy Launcher (Token Factory)
    console.log("3️⃣ Deploying Launcher (Token Factory)...");
    
    const launcher = await deployContract("TokenFactory", [factory.address, router.address], "Launcher");
    console.log("✅ Launcher (TokenFactory) deployed:", launcher.address);
    
    console.log("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");

    // 4. Deploy NexusGenerator
    console.log("4️⃣ Deploying NexusGenerator...");
    
    const nexusGenerator = await deployContract("NexusGenerator", [TestToken.address, multiStakingDistributor, nexusPerBlock, actualStartBlock, bonusEndBlock], "");
    console.log("✅ NexusGenerator deployed:", nexusGenerator.address);
    
    console.log("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");

    // 5. Configure TestToken Ownership (CRITICAL FIX)
    console.log("5️⃣ Configuring TestToken Ownership...");
    
    // Set up the multi-owner system for TestToken (needed for mint function)
    await TestToken.contract.setOwner(newOwnerAddress, nexusGenerator.address, newOwnerAddress);
    console.log("✅ TestToken multi-owner configured: owner1=", newOwnerAddress, ", owner2=", nexusGenerator.address, ", owner3=", newOwnerAddress);
    
    // Transfer main Ownable ownership
    await TestToken.contract.transferOwnership(newOwnerAddress);
    console.log("✅ TestToken main ownership transferred to:", newOwnerAddress);
    
    // Note: NexusFactory and NexusRouter don't need ownership transfer
    // NexusGenerator uses MultiOwnable pattern, ownership handled in constructor
    
    console.log("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");

    // 6. Summary
    console.log("🎉 DEPLOYMENT COMPLETE!");
    console.log("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
    console.log("📋 DEPLOYMENT SUMMARY:");
    console.log("🏭 NexusFactory:", factory.address);
    console.log("🔄 NexusRouter:", router.address);
    console.log("🪙 TestToken:", TestToken.address);
    console.log("🚀 Launcher (TokenFactory):", launcher.address);
    console.log("⚡ NexusGenerator:", nexusGenerator.address);
    console.log("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
    console.log("🔍 All contracts have been verified on the XRP EVM Explorer!");
    console.log("🌐 Explorer: https://explorer.xrplevm.org");
    console.log("👤 Owner: TestToken transferred to", newOwnerAddress);
    console.log("🔧 Configuration:");
    console.log("   • WXRP Address:", WXRP);
    console.log("   • Fee Setter:", feeToSetter);
    console.log("   • Multi Staking Distributor:", multiStakingDistributor);
    console.log("   • Nexus Per Block:", nexusPerBlock.toString());
    console.log("   • Start Block:", actualStartBlock);
    console.log("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
    console.log("✨ Your NexusSwap DEX with Token Launcher is now live on XRP EVM!");
    console.log("🚀 You can start trading, add liquidity pools, and launch new tokens!");
    console.log("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
}

main().catch((error) => {
    console.error("❌ Deployment failed:", error);
    process.exitCode = 1;
}); 
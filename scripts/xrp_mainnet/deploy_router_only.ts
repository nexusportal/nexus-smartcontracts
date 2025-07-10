import { ethers } from 'hardhat';
import * as dotenv from "dotenv";
import { deployContract } from '../utils';

dotenv.config();

// -----------------------
// DEPLOYED CONTRACT ADDRESSES & CONFIG
// -----------------------
const NEXUS_FACTORY_ADDRESS = "0x357444526Cd173b29290Da615cC5FcDEf2c4E3c0"; // The existing factory
const WXRP_ADDRESS = "0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE"; // Native XRP address
//------------------------

async function main() {
    console.log("🚀 Starting NexusRouterXRP Deployment...");
    console.log("📍 Network: XRP EVM Mainnet");
    console.log("🏭 Using Existing Factory:", NEXUS_FACTORY_ADDRESS);
    console.log("💧 WXRP Address:", WXRP_ADDRESS);
    console.log("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");

    // Deploy only the new NexusRouterXRP
    const router = await deployContract("NexusRouterXRP", [NEXUS_FACTORY_ADDRESS, WXRP_ADDRESS], "");
    
    console.log("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
    console.log("🎉 DEPLOYMENT COMPLETE!");
    console.log("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
    console.log("📋 DEPLOYMENT SUMMARY:");
    console.log("🔄 New NexusRouterXRP Deployed:", router.address);
    console.log("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
    console.log("✅ NexusRouterXRP has been deployed and verified!");
    console.log("🔧 You can now use this new router address in your dApp and for adding liquidity.");
    console.log("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
}

main().catch((error) => {
    console.error("❌ Deployment failed:", error);
    process.exitCode = 1;
}); 
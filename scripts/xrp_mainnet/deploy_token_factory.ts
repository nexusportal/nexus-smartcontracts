import { ethers } from "hardhat";
import { parseEther } from "ethers/lib/utils";
import hre from "hardhat";

async function main() {
    console.log("🚀 Starting TokenFactory (Launcher) Deployment...");
    console.log("📍 Network: XRP EVM Mainnet");
    console.log("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");

    const [deployer] = await ethers.getSigners();
    console.log("👤 Deployer:", deployer.address);
    console.log("💰 Balance:", ethers.utils.formatEther(await deployer.getBalance()), "XRP");
    console.log("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");

    // Configuration
    const FACTORY_ADDRESS = "0x357444526Cd173b29290Da615cC5FcDEf2c4E3c0"; // Existing Uniswap factory
    const ROUTER_ADDRESS = "0x466E71a43B68928a3f5A3056Ce930C3e50518141"; // Fixed XRP router
    
    console.log("🔧 Configuration:");
    console.log("   Uniswap Factory:", FACTORY_ADDRESS);
    console.log("   Uniswap Router:", ROUTER_ADDRESS);
    console.log("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");

    // Deploy TokenFactory
    console.log("1️⃣ Deploying TokenFactory...");
    const TokenFactory = await ethers.getContractFactory("TokenFactory");
    const tokenFactory = await TokenFactory.deploy(
        FACTORY_ADDRESS,
        ROUTER_ADDRESS
    );
    await tokenFactory.deployed();
    console.log("   ✅ TokenFactory deployed at:", tokenFactory.address);

    // Verify the contract
    console.log("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
    console.log("🔍 Verifying TokenFactory on XRP EVM Explorer...");
    
    try {
        await hre.run("verify:verify", {
            address: tokenFactory.address,
            constructorArguments: [
                FACTORY_ADDRESS,
                ROUTER_ADDRESS
            ],
        });
        console.log("✅ Verified TokenFactory on XRP EVM Explorer");
        console.log(`🔗 https://explorer.xrplevm.org/address/${tokenFactory.address}#code`);
    } catch (error: any) {
        console.log("⚠️ Verification failed:", error.message);
    }

    console.log("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
    console.log("2️⃣ Configuring TokenFactory...");
    
    // Set native fee (1 XRP)
    console.log("   Setting native fee to 1 XRP...");
    const setNativeFeeTx = await tokenFactory.setFee(ethers.constants.AddressZero, parseEther("1"));
    await setNativeFeeTx.wait();
    console.log("   ✅ Native fee set to 1 XRP");

    console.log("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
    console.log("🎉 DEPLOYMENT COMPLETE!");
    console.log("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
    console.log("📋 DEPLOYMENT SUMMARY:");
    console.log(`🏭 TokenFactory: ${tokenFactory.address}`);
    console.log(`💰 Native Fee: 1 XRP`);
    console.log(`🔧 Platform Fee: 1%`);
    console.log(`🏪 Factory: ${FACTORY_ADDRESS}`);
    console.log(`🔄 Router: ${ROUTER_ADDRESS}`);
    console.log("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
    console.log("✅ TokenFactory is ready for token creation!");
    console.log("🔧 Users can now create tokens with 1 XRP fee and custom initial liquidity.");
    console.log("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    }); 
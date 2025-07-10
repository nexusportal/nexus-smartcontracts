import { ethers } from "hardhat";
import { parseEther } from "ethers/lib/utils";
import hre from "hardhat";

async function main() {
    console.log("🚀 Starting NexusGenerator (Token Factory) Deployment...");
    console.log("📍 Network: XRP EVM Mainnet");
    console.log("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");

    const [deployer] = await ethers.getSigners();
    console.log("👤 Deployer:", deployer.address);
    console.log("💰 Balance:", ethers.utils.formatEther(await deployer.getBalance()), "XRP");
    console.log("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");

    // Configuration
    const FACTORY_ADDRESS = "0x357444526Cd173b29290Da615cC5FcDEf2c4E3c0"; // Existing factory
    const ROUTER_ADDRESS = "0x466E71a43B68928a3f5A3056Ce930C3e50518141"; // Fixed router
    const WXRP_ADDRESS = "0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE"; // Native XRP
    
    console.log("🔧 Configuration:");
    console.log("   Factory:", FACTORY_ADDRESS);
    console.log("   Router:", ROUTER_ADDRESS);
    console.log("   WXRP:", WXRP_ADDRESS);
    console.log("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");

    // Deploy NexusGenerator
    console.log("1️⃣ Deploying NexusGenerator...");
    const NexusGenerator = await ethers.getContractFactory("NexusGenerator");
    const nexusGenerator = await NexusGenerator.deploy(
        FACTORY_ADDRESS,
        ROUTER_ADDRESS,
        WXRP_ADDRESS
    );
    await nexusGenerator.deployed();
    console.log("   ✅ NexusGenerator deployed at:", nexusGenerator.address);

    // Verify the contract
    console.log("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
    console.log("🔍 Verifying NexusGenerator on XRP EVM Explorer...");
    
    try {
        await hre.run("verify:verify", {
            address: nexusGenerator.address,
            constructorArguments: [
                FACTORY_ADDRESS,
                ROUTER_ADDRESS,
                WXRP_ADDRESS
            ],
        });
        console.log("✅ Verified NexusGenerator on XRP EVM Explorer");
        console.log(`🔗 https://explorer.xrplevm.org/address/${nexusGenerator.address}#code`);
    } catch (error: any) {
        console.log("⚠️ Verification failed:", error.message);
    }

    console.log("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
    console.log("2️⃣ Configuring NexusGenerator...");
    
    // Set native token (XRP) configuration
    console.log("   Setting native token configuration...");
    const setNativeTx = await nexusGenerator.setNativeToken(
        WXRP_ADDRESS,
        true // isNative = true
    );
    await setNativeTx.wait();
    console.log("   ✅ Native token configured");

    // Set token creation fee (1 XRP)
    console.log("   Setting token creation fee to 1 XRP...");
    const setFeeTx = await nexusGenerator.setTokenCreationFee(parseEther("1"));
    await setFeeTx.wait();
    console.log("   ✅ Token creation fee set to 1 XRP");

    // Set minimum initial liquidity (1 XRP)
    console.log("   Setting minimum initial liquidity to 1 XRP...");
    const setMinLiquidityTx = await nexusGenerator.setMinInitialLiquidity(parseEther("1"));
    await setMinLiquidityTx.wait();
    console.log("   ✅ Minimum initial liquidity set to 1 XRP");

    console.log("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
    console.log("🎉 DEPLOYMENT COMPLETE!");
    console.log("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
    console.log("📋 DEPLOYMENT SUMMARY:");
    console.log(`🏭 NexusGenerator: ${nexusGenerator.address}`);
    console.log(`💰 Token Creation Fee: 1 XRP`);
    console.log(`💧 Min Initial Liquidity: 1 XRP`);
    console.log(`🪙 Native Token: ${WXRP_ADDRESS} (XRP)`);
    console.log("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
    console.log("✅ NexusGenerator is ready for token creation!");
    console.log("🔧 You can now create tokens with 1 XRP fee and 1 XRP initial liquidity.");
    console.log("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    }); 
import { ethers } from 'hardhat';
import * as dotenv from "dotenv";

dotenv.config();

// -----------------------
// DEPLOYED CONTRACT ADDRESSES  
// -----------------------
const NEXUS_FACTORY = "0x357444526Cd173b29290Da615cC5FcDEf2c4E3c0";
const NEXUS_ROUTER = "0x008CBe6822a86dED47fEF93f628F1a653B3012Ef";
const TEST_TOKEN = "0x9e0C30ee6519f715b337F1211eeC69d32A7E3915";
const TOKEN_FACTORY = "0x37F87D75E8Bb2fe07c8c28a886fa3ee2de77D4fd";
const NEXUS_GENERATOR = "0xc1cF84De273f1CD9Cec49b2aAae0F23a2AeEDd17";

async function main() {
    console.log("🔍 Checking XRP EVM Mainnet Configuration...");
    console.log("📍 Network: XRP EVM Mainnet");
    console.log("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");

    try {
        // Get contract instances
        const testToken = await ethers.getContractAt("TestToken", TEST_TOKEN);
        const nexusGenerator = await ethers.getContractAt("NexusGenerator", NEXUS_GENERATOR);
        const tokenFactory = await ethers.getContractAt("TokenFactory", TOKEN_FACTORY);
        const nexusFactory = await ethers.getContractAt("NexusFactory", NEXUS_FACTORY);

        console.log("📋 CURRENT CONFIGURATION:");
        console.log("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");

        // Check TestToken configuration
        console.log("🪙 TestToken Configuration:");
        const testTokenOwner = await testToken.owner();
        const testTokenOwner1 = await testToken.owner1();
        const testTokenOwner2 = await testToken.owner2();
        const testTokenOwner3 = await testToken.owner3();
        const testTokenTotalSupply = await testToken.totalSupply();
        const testTokenMaxSupply = await testToken.getMaxSupply();
        
        console.log("   📧 Main Owner:", testTokenOwner);
        console.log("   👤 Owner1:", testTokenOwner1);
        console.log("   👤 Owner2:", testTokenOwner2);
        console.log("   👤 Owner3:", testTokenOwner3);
        console.log("   📊 Total Supply:", ethers.utils.formatEther(testTokenTotalSupply), "TEST");
        console.log("   📈 Max Supply:", ethers.utils.formatEther(testTokenMaxSupply), "TEST");

        console.log("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");

        // Check NexusGenerator configuration
        console.log("⚡ NexusGenerator Configuration:");
        const treasury = await nexusGenerator.treasury();
        const nexusPerBlock = await nexusGenerator.nexusPerBlock();
        const multiStakingDistRate = await nexusGenerator.multiStakingDistRate();
        const poolLength = await nexusGenerator.poolLength();
        const startBlock = await nexusGenerator.startBlock();
        const bonusEndBlock = await nexusGenerator.bonusEndBlock();
        const multiStakingDistributor = await nexusGenerator.multiStakingDistributor();
        
        console.log("   🏦 Treasury:", treasury);
        console.log("   ⚡ Nexus Per Block:", nexusPerBlock.toString());
        console.log("   📈 Multi-Staking Rate:", multiStakingDistRate.toString(), "%");
        console.log("   📊 Pool Length:", poolLength.toString());
        console.log("   🎯 Start Block:", startBlock.toString());
        console.log("   🏁 Bonus End Block:", bonusEndBlock.toString());
        console.log("   📤 Multi-Staking Distributor:", multiStakingDistributor);

        console.log("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");

        // Check TokenFactory configuration
        console.log("🚀 TokenFactory Configuration:");
        const nativeFee = await tokenFactory.nativeFee();
        const platformFeePercent = await tokenFactory.platformFeePercent();
        const factoryOwner = await tokenFactory.owner();
        
        console.log("   💰 Native Fee:", ethers.utils.formatEther(nativeFee), "XRP");
        console.log("   📊 Platform Fee %:", platformFeePercent.toString(), "%");
        console.log("   👤 Owner:", factoryOwner);

        console.log("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");

        // Check NexusFactory configuration
        console.log("🏭 NexusFactory Configuration:");
        const feeTo = await nexusFactory.feeTo();
        const feeToSetter = await nexusFactory.feeToSetter();
        const allPairsLength = await nexusFactory.allPairsLength();
        
        console.log("   💰 Fee To:", feeTo);
        console.log("   🔧 Fee To Setter:", feeToSetter);
        console.log("   📊 Total Pairs:", allPairsLength.toString());

        console.log("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");

        // Status checks
        console.log("✅ STATUS CHECKS:");
        
        // Check if NexusGenerator can mint TestToken
        const isNexusGeneratorOwner = (testTokenOwner1 === NEXUS_GENERATOR || 
                                      testTokenOwner2 === NEXUS_GENERATOR || 
                                      testTokenOwner3 === NEXUS_GENERATOR);
        console.log("   🔨 NexusGenerator can mint TestToken:", isNexusGeneratorOwner ? "✅ YES" : "❌ NO");
        
        // Check if treasury is set
        const isTreasurySet = treasury !== ethers.constants.AddressZero;
        console.log("   🏦 Treasury is configured:", isTreasurySet ? "✅ YES" : "❌ NO");
        
        // Check if native fee is set
        const isNativeFeeSet = nativeFee.gt(0);
        console.log("   💰 TokenFactory fee is set:", isNativeFeeSet ? "✅ YES" : "❌ NO");
        
        // Check if farming is active
        const isFarmingActive = nexusPerBlock.gt(0);
        console.log("   🌾 Farming is active:", isFarmingActive ? "✅ YES" : "❌ NO (Nexus per block = 0)");

        console.log("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");

        // Ready status
        const isReady = isNexusGeneratorOwner && isTreasurySet && isNativeFeeSet;
        console.log("🎯 SYSTEM STATUS:", isReady ? "✅ READY FOR PRODUCTION" : "⚠️  NEEDS CONFIGURATION");
        
        if (!isReady) {
            console.log("🔧 TO FIX: Run 'npm run setup:xrp-mainnet' to configure all settings");
        }

        console.log("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");

    } catch (error: any) {
        console.error("❌ Error checking configuration:", error.message);
        process.exitCode = 1;
    }
}

main().catch((error) => {
    console.error("❌ Configuration check failed:", error);
    process.exitCode = 1;
}); 
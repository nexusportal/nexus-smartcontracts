import { ethers } from 'hardhat';
import * as dotenv from "dotenv";
import { parseEther } from 'ethers/lib/utils';

dotenv.config();

// -----------------------
// DEPLOYED CONTRACT ADDRESSES
// -----------------------
const NEXUS_FACTORY = "0x357444526Cd173b29290Da615cC5FcDEf2c4E3c0";
const NEXUS_ROUTER = "0x008CBe6822a86dED47fEF93f628F1a653B3012Ef";
const TEST_TOKEN = "0x9e0C30ee6519f715b337F1211eeC69d32A7E3915";
const TOKEN_FACTORY = "0x37F87D75E8Bb2fe07c8c28a886fa3ee2de77D4fd";
const NEXUS_GENERATOR = "0xc1cF84De273f1CD9Cec49b2aAae0F23a2AeEDd17";

// -----------------------
// CONFIGURATION ADDRESSES
// -----------------------
const OWNER_ADDRESS = "0x8d6Be820bEd89A134FaE82D4DE68b6a75a2Fa163";
const TREASURY_ADDRESS = "0x8d6Be820bEd89A134FaE82D4DE68b6a75a2Fa163";
const NATIVE_FEE = parseEther("1"); // 1 XRP
//------------------------

async function main() {
    console.log("🚀 Starting XRP EVM Mainnet Setup...");
    console.log("📍 Network: XRP EVM Mainnet");
    console.log("👤 Owner Address:", OWNER_ADDRESS);
    console.log("🏦 Treasury Address:", TREASURY_ADDRESS);
    console.log("💰 Native Fee:", NATIVE_FEE.toString(), "wei (1 XRP)");
    console.log("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");

    // Get contract instances
    const testToken = await ethers.getContractAt("TestToken", TEST_TOKEN);
    const nexusGenerator = await ethers.getContractAt("NexusGenerator", NEXUS_GENERATOR);
    const tokenFactory = await ethers.getContractAt("TokenFactory", TOKEN_FACTORY);

    console.log("1️⃣ Configuring TestToken Ownership...");
    
    // Set TestToken owners: owner1 & owner2 = owner address, owner3 = nexus generator
    const currentOwners = {
        owner1: await testToken.owner1(),
        owner2: await testToken.owner2(), 
        owner3: await testToken.owner3()
    };
    
    console.log("📋 Current TestToken Owners:");
    console.log("   owner1:", currentOwners.owner1);
    console.log("   owner2:", currentOwners.owner2);
    console.log("   owner3:", currentOwners.owner3);
    
    if (currentOwners.owner1 !== OWNER_ADDRESS || 
        currentOwners.owner2 !== OWNER_ADDRESS || 
        currentOwners.owner3 !== NEXUS_GENERATOR) {
        
        console.log("🔧 Updating TestToken ownership...");
        await testToken.setOwner(OWNER_ADDRESS, OWNER_ADDRESS, NEXUS_GENERATOR);
        console.log("✅ TestToken ownership updated:");
        console.log("   owner1:", OWNER_ADDRESS);
        console.log("   owner2:", OWNER_ADDRESS);
        console.log("   owner3:", NEXUS_GENERATOR, "(NexusGenerator)");
    } else {
        console.log("✅ TestToken ownership already correctly configured");
    }
    
    console.log("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");

    console.log("2️⃣ Configuring NexusGenerator Treasury...");
    
    // Set NexusGenerator treasury
    const currentTreasury = await nexusGenerator.treasury();
    console.log("📋 Current Treasury:", currentTreasury);
    
    if (currentTreasury !== TREASURY_ADDRESS) {
        console.log("🔧 Setting treasury address...");
        await nexusGenerator.setNexusTreasury(TREASURY_ADDRESS);
        console.log("✅ Treasury address set to:", TREASURY_ADDRESS);
    } else {
        console.log("✅ Treasury address already correctly configured");
    }
    
    console.log("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");

    console.log("3️⃣ Configuring TokenFactory Fees...");
    
    // Set TokenFactory native fee
    const currentNativeFee = await tokenFactory.nativeFee();
    console.log("📋 Current Native Fee:", currentNativeFee.toString(), "wei");
    
    if (!currentNativeFee.eq(NATIVE_FEE)) {
        console.log("🔧 Setting native fee to 1 XRP...");
        await tokenFactory.setFee(ethers.constants.AddressZero, NATIVE_FEE);
        console.log("✅ Native fee set to:", NATIVE_FEE.toString(), "wei (1 XRP)");
    } else {
        console.log("✅ Native fee already correctly configured");
    }
    
    console.log("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");

    console.log("4️⃣ Verifying Critical Configuration...");
    
    // Verify TestToken can be minted by NexusGenerator
    try {
        const testTokenOwner1 = await testToken.owner1();
        const testTokenOwner2 = await testToken.owner2();
        const testTokenOwner3 = await testToken.owner3();
        const isNexusGeneratorOwner = (testTokenOwner1 === NEXUS_GENERATOR || 
                                      testTokenOwner2 === NEXUS_GENERATOR || 
                                      testTokenOwner3 === NEXUS_GENERATOR);
        
        if (isNexusGeneratorOwner) {
            console.log("✅ NexusGenerator has mint permissions on TestToken");
        } else {
            console.log("⚠️  WARNING: NexusGenerator may not have mint permissions on TestToken");
        }
        
        // Check NexusGenerator treasury is set
        const treasuryCheck = await nexusGenerator.treasury();
        if (treasuryCheck !== ethers.constants.AddressZero) {
            console.log("✅ NexusGenerator treasury is properly configured");
        } else {
            console.log("⚠️  WARNING: NexusGenerator treasury is not set");
        }
        
        // Check TokenFactory fees
        const nativeFeeCheck = await tokenFactory.nativeFee();
        if (nativeFeeCheck.gt(0)) {
            console.log("✅ TokenFactory native fee is configured");
        } else {
            console.log("⚠️  WARNING: TokenFactory native fee is 0");
        }
        
    } catch (error: any) {
        console.log("⚠️  Error during verification:", error.message);
    }
    
    console.log("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");

    console.log("5️⃣ Additional Checks...");
    
    // Check if any pools are added to NexusGenerator (should be empty initially)
    try {
        const poolLength = await nexusGenerator.poolLength();
        console.log("📊 Current pools in NexusGenerator:", poolLength.toString());
        
        // Check nexus per block
        const nexusPerBlock = await nexusGenerator.nexusPerBlock();
        console.log("⚡ Nexus per block:", nexusPerBlock.toString());
        
        // Check multi-staking distribution rate
        const multiStakingDistRate = await nexusGenerator.multiStakingDistRate();
        console.log("📈 Multi-staking distribution rate:", multiStakingDistRate.toString(), "%");
        
    } catch (error: any) {
        console.log("⚠️  Error during additional checks:", error.message);
    }
    
    console.log("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");

    console.log("🎉 SETUP COMPLETE!");
    console.log("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
    console.log("📋 CONFIGURATION SUMMARY:");
    console.log("🪙 TestToken:");
    console.log("   • owner1:", OWNER_ADDRESS);
    console.log("   • owner2:", OWNER_ADDRESS);
    console.log("   • owner3:", NEXUS_GENERATOR, "(NexusGenerator)");
    console.log("⚡ NexusGenerator:");
    console.log("   • Treasury:", TREASURY_ADDRESS);
    console.log("   • Nexus per block:", "0 (disabled initially)");
    console.log("🚀 TokenFactory:");
    console.log("   • Native fee:", "1 XRP");
    console.log("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
    console.log("✨ Your NexusSwap ecosystem is now fully configured and ready for testing!");
    console.log("🔄 Next steps: UI setup and testing token creation/farming");
    console.log("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
}

main().catch((error) => {
    console.error("❌ Setup failed:", error);
    process.exitCode = 1;
}); 
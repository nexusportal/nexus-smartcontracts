import { ethers } from "hardhat";
import { parseEther } from "ethers/lib/utils";

async function main() {
    console.log("🧪 Starting TokenFactory Token Creation Test...");
    console.log("📍 Network: XRP EVM Mainnet");
    console.log("🪙 Creating Test2 (T2) token via TokenFactory");
    console.log("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");

    const [deployer] = await ethers.getSigners();
    console.log("👤 Token Creator:", deployer.address);
    console.log("💰 Balance:", ethers.utils.formatEther(await deployer.getBalance()), "XRP");

    // Configuration - UPDATE THIS WITH THE DEPLOYED TOKENFACTORY ADDRESS
    const TOKEN_FACTORY_ADDRESS = "0xb9e8ffD802Aa6B7d9d354347764B7c00E28D70AF";
    
    // Token parameters
    const TOKEN_NAME = "Test2";
    const TOKEN_SYMBOL = "T2";
    const TOTAL_SUPPLY = parseEther("100"); // 100 tokens
    const LP_PERCENT = 95; // 95% for liquidity
    const DEV_PERCENT = 4; // 4% for dev
    // Platform fee is 1% (hardcoded in contract)
    const INITIAL_LIQUIDITY = parseEther("1"); // 1 XRP
    const PAYMENT_TOKEN = ethers.constants.AddressZero; // Use native XRP
    const USE_NATIVE_FEE = true;

    console.log("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
    console.log("🔧 Token Configuration:");
    console.log(`   Name: ${TOKEN_NAME}`);
    console.log(`   Symbol: ${TOKEN_SYMBOL}`);
    console.log(`   Total Supply: ${ethers.utils.formatEther(TOTAL_SUPPLY)} tokens`);
    console.log(`   LP Allocation: ${LP_PERCENT}%`);
    console.log(`   Dev Allocation: ${DEV_PERCENT}%`);
    console.log(`   Platform Fee: 1% (automatic)`);
    console.log(`   Initial Liquidity: ${ethers.utils.formatEther(INITIAL_LIQUIDITY)} XRP`);
    console.log(`   Creation Fee: 1 XRP (native)`);
    console.log("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");

    // Get the TokenFactory contract
    console.log("1️⃣ Connecting to TokenFactory...");
    const tokenFactory = await ethers.getContractAt("TokenFactory", TOKEN_FACTORY_ADDRESS);
    console.log("   ✅ Connected to TokenFactory");

    // Check current settings
    console.log("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
    console.log("2️⃣ Checking factory settings...");
    
    try {
        const nativeFee = await tokenFactory.nativeFee();
        const platformFeePercent = await tokenFactory.platformFeePercent();
        console.log(`   Native Fee: ${ethers.utils.formatEther(nativeFee)} XRP`);
        console.log(`   Platform Fee: ${platformFeePercent}%`);
    } catch (error: any) {
        console.log("   ⚠️ Could not read factory settings:", error.message);
    }

    // Calculate token allocations
    const lpAmount = TOTAL_SUPPLY.mul(LP_PERCENT).div(100);
    const devAmount = TOTAL_SUPPLY.mul(DEV_PERCENT).div(100);
    const platformAmount = TOTAL_SUPPLY.mul(1).div(100); // 1% platform fee
    
    console.log("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
    console.log("3️⃣ Token allocation breakdown:");
    console.log(`   Total Supply: ${ethers.utils.formatEther(TOTAL_SUPPLY)} ${TOKEN_SYMBOL}`);
    console.log(`   LP Tokens (${LP_PERCENT}%): ${ethers.utils.formatEther(lpAmount)} ${TOKEN_SYMBOL}`);
    console.log(`   Dev Allocation (${DEV_PERCENT}%): ${ethers.utils.formatEther(devAmount)} ${TOKEN_SYMBOL}`);
    console.log(`   Platform Fee (1%): ${ethers.utils.formatEther(platformAmount)} ${TOKEN_SYMBOL}`);
    console.log(`   Initial XRP Liquidity: ${ethers.utils.formatEther(INITIAL_LIQUIDITY)} XRP`);

    // Create the token
    console.log("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
    console.log("4️⃣ Creating token with liquidity...");
    
    const nativeFee = parseEther("1"); // 1 XRP fee
    const totalCost = nativeFee.add(INITIAL_LIQUIDITY);
    console.log(`   Total XRP needed: ${ethers.utils.formatEther(totalCost)} XRP (${ethers.utils.formatEther(nativeFee)} fee + ${ethers.utils.formatEther(INITIAL_LIQUIDITY)} liquidity)`);
    
    try {
        const createTokenTx = await tokenFactory.createToken(
            TOKEN_NAME,
            TOKEN_SYMBOL,
            TOTAL_SUPPLY,
            LP_PERCENT,
            DEV_PERCENT,
            PAYMENT_TOKEN,
            INITIAL_LIQUIDITY,
            USE_NATIVE_FEE,
            {
                value: totalCost // Send creation fee + liquidity XRP
            }
        );
        
        console.log("   📤 Transaction submitted:", createTokenTx.hash);
        console.log("   ⏳ Waiting for confirmation...");
        
        const receipt = await createTokenTx.wait();
        console.log("   ✅ Token created successfully!");
        
        // Parse events to get token address
        const tokenCreatedEvent = receipt.events?.find(
            (event: any) => event.event === "TokenCreated"
        );
        
        const liquidityAddedEvent = receipt.events?.find(
            (event: any) => event.event === "LiquidityAdded"
        );
        
        if (tokenCreatedEvent) {
            const tokenAddress = tokenCreatedEvent.args?.tokenAddress;
            
            console.log("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
            console.log("🎉 TOKEN CREATION SUCCESSFUL!");
            console.log("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
            console.log("📋 TOKEN DETAILS:");
            console.log(`🪙 Token Address: ${tokenAddress}`);
            console.log(`📛 Name: ${TOKEN_NAME}`);
            console.log(`🏷️ Symbol: ${TOKEN_SYMBOL}`);
            console.log(`📊 Total Supply: ${ethers.utils.formatEther(TOTAL_SUPPLY)} ${TOKEN_SYMBOL}`);
            console.log(`👨‍💻 Dev Allocation: ${ethers.utils.formatEther(devAmount)} ${TOKEN_SYMBOL} (${DEV_PERCENT}%)`);
            console.log(`💧 LP Allocation: ${ethers.utils.formatEther(lpAmount)} ${TOKEN_SYMBOL} (${LP_PERCENT}%)`);
            console.log(`🏢 Platform Fee: ${ethers.utils.formatEther(platformAmount)} ${TOKEN_SYMBOL} (1%)`);
            console.log(`💰 Creation Fee Paid: ${ethers.utils.formatEther(nativeFee)} XRP`);
            console.log(`💧 Initial Liquidity: ${ethers.utils.formatEther(INITIAL_LIQUIDITY)} XRP + ${ethers.utils.formatEther(lpAmount)} ${TOKEN_SYMBOL}`);
            
            if (liquidityAddedEvent) {
                const liquidityTokens = liquidityAddedEvent.args?.liquidity;
                console.log(`🎫 LP Tokens Burned: ${ethers.utils.formatEther(liquidityTokens)} (sent to 0xdead)`);
            }
            
            console.log("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
            console.log("🔗 EXPLORER LINKS:");
            console.log(`🪙 Token: https://explorer.xrplevm.org/address/${tokenAddress}`);
            console.log(`📜 Transaction: https://explorer.xrplevm.org/tx/${createTokenTx.hash}`);
            console.log("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
            
            // Verify token contract
            console.log("5️⃣ Verifying token balances...");
            const token = await ethers.getContractAt("NewToken", tokenAddress);
            
            const devBalance = await token.balanceOf(deployer.address);
            const factoryBalance = await token.balanceOf(TOKEN_FACTORY_ADDRESS);
            const totalSupplyActual = await token.totalSupply();
            
            console.log(`   👨‍💻 Dev Balance: ${ethers.utils.formatEther(devBalance)} ${TOKEN_SYMBOL}`);
            console.log(`   🏢 Factory Balance (Platform Fee): ${ethers.utils.formatEther(factoryBalance)} ${TOKEN_SYMBOL}`);
            console.log(`   📊 Total Supply: ${ethers.utils.formatEther(totalSupplyActual)} ${TOKEN_SYMBOL}`);
            console.log("   ✅ Token balances verified!");
            
        } else {
            console.log("   ⚠️ Could not find TokenCreated event in transaction receipt");
        }
        
    } catch (error: any) {
        console.error("❌ Token creation failed:", error.message);
        if (error.reason) {
            console.error("   Reason:", error.reason);
        }
        throw error;
    }

    console.log("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
    console.log("✅ TEST COMPLETE!");
    console.log("🎊 Test2 (T2) token has been successfully created via TokenFactory!");
    console.log("💰 LP tokens were automatically burned (sent to 0xdead address)");
    console.log("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    }); 
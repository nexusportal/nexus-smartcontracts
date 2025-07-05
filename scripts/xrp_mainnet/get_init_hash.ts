import { ethers } from 'hardhat';

async function main() {
    console.log("🔍 Calculating NexusSwapPair Init Code Hash...");
    
    // Get the contract factory
    const NexusSwapPair = await ethers.getContractFactory("NexusSwapPair");
    
    // Get the bytecode
    const bytecode = NexusSwapPair.bytecode;
    
    // Calculate the hash (same as in factory)
    const hash = ethers.utils.keccak256(bytecode);
    
    console.log("📋 Results:");
    console.log("🔹 Bytecode length:", bytecode.length);
    console.log("🔹 Init Code Hash:", hash);
    console.log("🔹 For NexusSwapLibrary.sol, use:");
    console.log(`   hex"${hash.slice(2)}"`);
    
    return hash;
}

main().catch((error) => {
    console.error("❌ Error:", error);
    process.exitCode = 1;
}); 
import { Contract } from "ethers"
import hre, { ethers, run } from "hardhat"
import fs from "fs"
import path from "path"
const util = require('util');
const exec = util.promisify(require('child_process').exec);
import axios from "axios";

export const deployContract = async function (name: string, params: any, periphery: string) {

    let conName = periphery === "" ? `${name}` : `${periphery}/${name}`
    await flattenContract(conName, periphery)
    const factory = await ethers.deployContract(name, params)
    const contract = await factory.deployed()
    let address = factory.address
    await contract.deployTransaction.wait(5);

    console.log(name, address)

    fs.mkdirSync(`scripts/params`, { recursive: true });
    fs.mkdirSync(`scripts/result`, { recursive: true });
    const outputCodes = `module.exports = ${JSON.stringify(params)}`
    const resultCodes = `${name} : ${address}`;
    fs.writeFileSync(`scripts/params/${name}_var.ts`, outputCodes);
    fs.writeFileSync(`scripts/result/${name}_res.result`, resultCodes);
    
    // Auto-verify contracts after deployment
    await verifyContract(address, name, conName, params);

    return { contract, address }
}

export const flattenContract = async (contractName: string, outputDir: string) => {
    try {
        console.log(`contracts/${contractName}.sol`)
        console.log(`flatten/${contractName}_flattened.sol`)
        fs.mkdirSync(`flatten/${outputDir}`, { recursive: true });
        await exec(`npx hardhat flatten contracts/${contractName}.sol > flatten/${contractName}_flattened.sol`)
        await exec(`cls`)
        return true;
    } catch (e) {
        console.log(e)
        return false
    }
}

export const verifyContract = async (address: string, name: string, conName: string, params: any) => {
    try {
        const networkName = hre.network.name;
        console.log(`🔍 Verifying ${name} on ${networkName}...`);
        
        const data = fs.readFileSync(`flatten/${conName}_flattened.sol`, 'utf-8');
        
        if (networkName.includes('xrp') || networkName === 'xrp_evm_mainnet' || networkName === 'xrp_evm_testnet') {
            // XRP EVM Verification
            const explorerUrl = networkName.includes('testnet') || networkName === 'xrp_evm_testnet' 
                ? "https://evm-sidechain.xrpl.org" 
                : "https://explorer.xrplevm.org";
                
            try {
                // For XRP EVM, we'll use Hardhat's built-in verification if available
                // Otherwise, we can implement custom verification logic here
                await hre.run("verify:verify", {
                    address: address,
                    constructorArguments: params,
                });
                console.log(`✅ Verified ${name} (${address}) on XRP EVM Explorer`);
            } catch (verifyError) {
                console.log(`⚠️ Hardhat verification failed for ${name}, trying custom verification...`);
                
                // Custom verification for XRP EVM (if needed)
                // This would require implementing the specific API calls for XRP EVM
                console.log(`📝 Contract ${name} deployed but verification may need manual completion`);
                console.log(`🔗 Check manually at: ${explorerUrl}/address/${address}`);
            }
            
        } else if (networkName === 'xdc' || networkName === 'mainnet') {
            // XDC Network Verification (original logic)
            await axios.post("https://xdc.network/api/contracts", {
                contractAddress: address,
                contractName: name,
                optimization: 0,
                sourceCode: data,
                version: "13"
            });
            console.log(`✅ Verified ${name} (${address}) on XDC Network`);
            
        } else {
            // For other networks, try standard Hardhat verification
            try {
                await hre.run("verify:verify", {
                    address: address,
                    constructorArguments: params,
                });
                console.log(`✅ Verified ${name} (${address}) using Hardhat`);
            } catch (verifyError) {
                console.log(`⚠️ Verification failed for ${name}: ${verifyError.message}`);
            }
        }
        
    } catch (err) { 
        console.log(`❌ Error occurs in ${conName} verification:`, err.message) 
    }
}
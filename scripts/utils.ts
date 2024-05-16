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
    try {
        const data = fs.readFileSync(`flatten/${conName}_flattened.sol`, 'utf-8');
        await axios.post("https://xdc.network/api/contracts", {
            contractAddress: address,
            contractName: name,
            optimization: 0,
            sourceCode: data,
            version: "13"
        })
        console.log(`Verified ${name} (${address})`)
    } catch (err) { console.log(`Error occurs in ${conName}`) }

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
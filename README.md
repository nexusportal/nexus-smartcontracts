# Sample Hardhat Project

This project demonstrates a basic Hardhat use case. It comes with a sample contract, a test for that contract, and a script that deploys that contract.

Try running some of the following tasks:

npx hardhat test
REPORT_GAS=true npx hardhat test
npx hardhat node
npx hardhat run scripts/deploy.ts
```
npx hardhat run scripts/deploy.ts --network apothem
npx hardhat verify --network apothem --constructor-args scripts/arg_arc.ts <address> 

npx hardhat flatten contracts/NexusNFT.sol > flatten/NexusNFT.sol
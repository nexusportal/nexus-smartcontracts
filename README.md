# Sample Hardhat Project

This project demonstrates a basic Hardhat use case. It comes with a sample contract, a test for that contract, and a script that deploys that contract.

Try running some of the following tasks:

npx hardhat test
REPORT_GAS=true npx hardhat test
npx hardhat node
npx hardhat run scripts/deploy.ts
```
npx hardhat run scripts/dex_deploy.ts --network xrp_evm
npx hardhat verify --network xrp_evm --constructor-args scripts/arg_arc.ts <address> 

npx hardhat flatten contracts/x.sol > flatten/x.sol
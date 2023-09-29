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

npx hardhat flatten contracts/NexusRouter.sol > flatten/NexusRouter.sol
npx hardhat flatten contracts/NexusFactory.sol > flatten/NexusFactory.sol
npx hardhat flatten contracts/NexusGenerator.sol > flatten/NexusGenerator.sol
npx hardhat flatten contracts/NexusDiffuser.sol > flatten/NexusDiffuser.sol
npx hardhat flatten contracts/NexusNFTMultiStaking.sol > flatten/NexusNFTMultiStaking.sol
npx hardhat flatten contracts/NexusNFTMultiStakingDistributor.sol > flatten/NexusNFTMultiStakingDistributor.sol
npx hardhat flatten contracts/DistributeNexus.sol > flatten/DistributeNexus.sol
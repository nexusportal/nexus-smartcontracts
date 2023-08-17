# Sample Hardhat Project

This project demonstrates a basic Hardhat use case. It comes with a sample contract, a test for that contract, and a script that deploys that contract.

Try running some of the following tasks:

npx hardhat test
REPORT_GAS=true npx hardhat test
npx hardhat node
npx hardhat run scripts/deploy.ts
```
npx hardhat run scripts/deploy.ts --network coston2
npx hardhat verify --network coston2 --constructor-args scripts/arg_arc.ts <address> 

npx hardhat run scripts/deploy.ts --network flare
npx hardhat verify --network flare --constructor-args scripts/arg_arc.ts <address> 
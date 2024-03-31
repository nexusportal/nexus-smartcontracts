# 🌌 Welcome To The Nexus Interface

## The Nexus Interface & Smart Contracts that bring the Nexus Portal To Life!

## GitHub Repositories
- [Nexus Interface](https://github.com/nexusportal/nexus-interface)
- [Nexus Smart Contracts](https://github.com/nexusportal/nexus-smartcontracts)

## Primary Smart Contract and UI Components

### NEXUS TOKEN
The NEXU token has a 1.1 Billion max supply. It is Minted by the NexusGenerator starting at 5 NEXU per block and slowly decreasing in distribution rate over time (similar to the Bitcoin Halving mechanism). 90% of these newly minted NEXU rewards go to liquidity providers and 10% of the NEXU minted goes to the Nexus Core Multi-Staking. NEXU Token can be staked by itself or paired with an NFT in the Nexus Core Multi-Staking. Users can time-lock their NEXU and NFTs to gain multipliers in their share of the pool. The NEXU Token will be used to Govern The Nexus.
- [NEXUS TOKEN](https://github.com/nexusportal/nexus-smartcontracts/blob/main/contracts/NexusToken.sol)

### NEXUS GENERATOR(Yield Farming Contract)
This is where users can stake their liquidity tokens ($NLPs) to earn $NEXU and potentially more Superfarm Rewards.
- [NEXUS GENERATOR](https://github.com/nexusportal/nexus-smartcontracts/blob/main/contracts/NexusGenerator.sol)

### NEXUS FACTORY
Swapping Contract/Liquidity Token Manager. Fees generated by the Factory contract are sent to the NexusDiffuser to be distributed back to users.
- [NEXUS FACTORY](https://github.com/nexusportal/nexus-smartcontracts/blob/main/contracts/NexusFactory.sol)

### NEXUS ROUTER
Routes Paths for Token Swaps.
- [NEXUS ROUTER](https://github.com/nexusportal/nexus-smartcontracts/blob/main/contracts/NexusRouter.sol)

### NEXUS LIQUIDITY TOKENS $NLP
Liquidity Tokens represent different tokens pairs created by the community.

### NEXUS DIFFUSER
The Nexus Diffuser receives $NLPs of different kinds from the Nexus Factory setFeeToo. The Diffuser buys and burns $NEXU with some of those $NLPs (primarily WXRP/NEXU). The rest of the $NLPs are and sent to the Nexus Core Multi-Staking to be distributed proportionally to $NEXU/$ETHER Stakers.
- [NEXUS DIFFUSER](https://github.com/nexusportal/nexus-smartcontracts/blob/main/contracts/NexusDiffuser.sol)

### NEXUS ETHEREALS NFTS
There are 11,111 AI Generated Nexus Ethereal NFTs! Each NFT holds a share of the Nexus Core Multi-Staking pool. NFTs can be staked in the Nexus Core Multi-Staking system to earn NEXU token and NLPs.
- [NEXUS ETHEREALS NFTS](https://github.com/nexusportal/nexus-smartcontracts/blob/main/contracts/NexusNFT.sol)

### NEXUS NFT WEIGHTS
The Nexus NFT weights are stored in this smart contract. The Nexus Core Multi-Staking gets the weight values from here so it knows how to distribute the rewards to the users.
- [NEXUS NFT WEIGHTS](https://github.com/nexusportal/nexus-smartcontracts/blob/main/contracts/NexusNFTWeight.sol)

### NEXUS CORE MULTISTAKING
The Nexus Core is where users can stake and time-lock their $NEXU Tokens and Nexus NFTs to earn $NEXU, $NLPs and potentially other Tokens from many different sources. Some sources may including fees from Superfarm deposits and
- [NEXUS CORE MULTISTAKING](https://github.com/nexusportal/nexus-smartcontracts/blob/main/contracts/NexusNFTMultiStaking.sol)

### NEXUS CORE MULTISTAKING DISTRIBUTOR
The Nexus Core Multi-Staking Distributor acts as a proxy contract for the different ERC-20 and Native token distributions. This is a security measure to make sure no one can take advantage of the Multi-Staking Contract rewards distribution. The "Distribute" button is publicly called by users to distribute rewards.
- [NEXUS CORE MULTISTAKING DISTRIBUTOR](https://github.com/nexusportal/nexus-smartcontracts/blob/main/contracts/NexusNFTMultiStakingDistributor.sol)

 
## Hardhat Deployment 🚀

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

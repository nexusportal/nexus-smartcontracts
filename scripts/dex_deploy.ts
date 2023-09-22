import { ethers } from 'hardhat';
import { WETH9, admin, NexusToken, NexusNFT, multistakingDistributor } from './var';

async function main() {
  // const NexusFactory = await ethers.getContractFactory('NexusFactory');
  // const nexusFactory = await NexusFactory.deploy(admin);
  // await nexusFactory.deployed();
  // console.log('const factory = "', nexusFactory.address, '"');

  // const NexusRouter = await ethers.getContractFactory('NexusRouter');
  // const nexusRouter = await NexusRouter.deploy(nexusFactory.address, WETH9);
  // await nexusRouter.deployed();
  // console.log('const router = "', nexusRouter.address, '"');


  // const MultiStaking = await ethers.getContractFactory('NexusNFTMultiStakingDistributor');
  //   const multiStaking = await MultiStaking.deploy(admin);
  //   await multiStaking.deployed();
  //   console.log('const multistaking = "', multiStaking.address, '"');

  // const NEXUS_NFT_Weight = await ethers.getContractFactory('NexusNFTWeight');
  //   const nEXUS_NFT_Weight = await NEXUS_NFT_Weight.deploy();
  //   await nEXUS_NFT_Weight.deployed();
  //   console.log('const NEXUS_NFT_Weight = "', nEXUS_NFT_Weight.address, '"');

  // const NEXUS_NFT_MULTISTAKING = await ethers.getContractFactory('NexusNFTMultiStaking');
  //   const NexusNFTMultiStaking = await NEXUS_NFT_MULTISTAKING.deploy(
  //     NexusToken,
  //     NexusNFT, 
  //     nEXUS_NFT_Weight.address );
  //   await NexusNFTMultiStaking.deployed();
  //   console.log('const NexusNFTMultiStaking = "', NexusNFTMultiStaking.address, '"');


    const blockNumBefore = await ethers.provider.getBlockNumber();
    const NexusGenerator = await ethers.getContractFactory('NexusGenerator');
    const superfarm = await NexusGenerator.deploy(NexusToken, multistakingDistributor, ethers.utils.parseEther('5'), blockNumBefore, 1);
    await superfarm.deployed();
    console.log('const superfarm = "', superfarm.address, '"');

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

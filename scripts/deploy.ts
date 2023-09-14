import { ethers } from "hardhat";

async function main() {
  const NexusNFT = await ethers.getContractFactory("NexusEtherealsNFT");
  const nexusNFT = await NexusNFT.deploy(
    "Nexus Ethereals",
    "$ETHER",
    "https://ethereals.fra1.cdn.digitaloceanspaces.com/metadata/",
    "https://ethereals.fra1.cdn.digitaloceanspaces.com/images/1.jpeg"
  );

  await nexusNFT.deployed();

  console.log("NFT address: ", nexusNFT.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

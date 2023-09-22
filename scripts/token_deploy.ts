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

  //Will deploy the same token 3times for testing on XRP EVM SideChain.
  // const erc20 = await ethers.getContractFactory("MyNToken");
  // const token1 = await erc20.deploy("MyFirstToken", "ONE")
  // const token2 = await erc20.deploy("MySecondToken", "TWO")
  // const token3 = await erc20.deploy("MyThirdToken", "THREE")
  // await token1.deployed();
  // await token2.deployed();
  // await token3.deployed();
  // console.log("const Token1 = '", token1.address, "'");
  // console.log("const Token2 = '", token2.address, "'")
  // console.log("const Token3 = '", token3.address, "'")

  // const NexusToken = await ethers.getContractFactory("NexusToken");
  // const nexusToken = await NexusToken.deploy();
  // await nexusToken.deployed();
  // console.log("const NexusToken = '", nexusToken.address, "'");

  // const CalHash = await ethers.getContractFactory("CalHash");
  // const calHash = await CalHash.deploy();
  // const res = await calHash.getInitHash();
  // console.log("initcodehash : ", res)
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

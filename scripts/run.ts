import { ethers } from 'hardhat';
import { ABI as factoryABI } from "./factory";
import { ABI as superABI } from "./superfarm";
import { ABI as ERC20ABI } from "./erc20";
import { factory, admin, superfarm, FIRE, EARTH, SPACE, WATER, NexusToken, weth9, AIR, xBTC, xETH, xXRP, xUSDC, xUSDT, WAN, nexusDiffuser } from './apothem/var';
import * as dotenv from "dotenv";
import { parseEther } from 'ethers/lib/utils';

dotenv.config();
const pk = process.env.PK ?? "";
const RPCURL = "https://erpc.apothem.network";

async function main() {
  const provider = new ethers.providers.JsonRpcProvider(RPCURL);
  const trybSenderWallet = new ethers.Wallet(pk, provider)
  const factorycontract = new ethers.Contract(factory, factoryABI, trybSenderWallet);
  const superfarmcontract = new ethers.Contract(superfarm, superABI, trybSenderWallet);
  const tokens = [
    '0xB2aAC0b50c42ee8a7309DCE4092749b98E2a9052',
    '0x5a3D18D2f52f9f424c9A5B0dBAfeb327cDA01F10',
    '0xef24e7461e3C06B0E0c94ABd869e7Af520783826',
    '0xC6b2806AA5d1a83117C8332413e239dab469357D',
    '0x70C7Dac54666ACF89FACe22203B2c9ffE72fCC43',
    '0xE84569d385f7642ccAb3439d7d314549333AA81d'
  ]

  const lps = [
    "0x9705315D20783aFe33EEd776f7C6027a745f24c8",
    "0x12aEa4b264cC09ceE533F2a715bFf444f03aA7d3",
    "0x17a623D8a27219B99959209a2c8fE7674EfBcb4f",
    "0x8049767C5b86e0d70dFf86D85C5393FC60E6575D",
    "0x8fea44273a773e0C3503429284B844B52239c39E",
    "0xDdb77490c342ed11102CCfa6D7ab2d404bC606D8",
    "0x7103555E90699fFbFFef0eC8BaE375fd24622829",
  ]
  const i = 2;
  const alloc = 5
  //   const element = tokens[i];
  //   const token  = new ethers.Contract(element, ERC20ABI, trybSenderWallet);
  //   await token.approve(superfarm, parseEther("10000"));
  // for (let i = 0; i < lps.length; i++) {
  const element = lps[i];
  // await superfarmcontract.add(alloc, element, false);
  // await superfarmcontract.setRewardToken(element, EARTH, 1);
  // await superfarmcontract.setRewardToken(element, AIR, 1);
  // await superfarmcontract.setRewardToken(element, FIRE, 1);
  // await superfarmcontract.setRewardToken(element, SPACE, 1);
  // await superfarmcontract.setRewardToken(element, WATER, 1);  
  // const  EARTHCon = new ethers.Contract(EARTH, ERC20ABI, trybSenderWallet);
  // const  AIRCon = new ethers.Contract(AIR, ERC20ABI, trybSenderWallet);
  // const  FIRECon = new ethers.Contract(FIRE, ERC20ABI, trybSenderWallet);
  // const  SPACECon = new ethers.Contract(SPACE, ERC20ABI, trybSenderWallet);
  // const  WATERCon = new ethers.Contract(WATER, ERC20ABI, trybSenderWallet);
  const  lpToken = new ethers.Contract(element, ERC20ABI, trybSenderWallet);
  // await lpToken.approve(nexusDiffuser, parseEther("20"));
  await lpToken.transfer(nexusDiffuser, parseEther("20"))
  // await EARTHCon.mint(admin, parseEther("10000000000"));
  // await AIRCon.mint(admin, parseEther("10000000000"));
  // await FIRECon.mint(admin, parseEther("10000000000"));
  // await SPACECon.mint(admin, parseEther("10000000000"));
  // await WATERCon.mint(admin, parseEther("10000000000"));
  // await superfarmcontract.
  // }



  // const allpairslen = await factorycontract.allPairsLength();
  // console.log("All Pairs: ", allpairslen);
  // for (let i = 0; i < allpairslen; i++) {
  //   const pair = await factorycontract.allPairs(i);
  //   console.log("pair : ", pair);
  // }
  // console.log("NEXU / xBTC:", await factorycontract.getPair(NexusToken, xBTC))
  // console.log("NEXU / xETH:", await factorycontract.getPair(NexusToken , xETH))
  // console.log("NEXU / xXRP:", await factorycontract.getPair(NexusToken, xXRP))
  // console.log("NEXU / xUSDC:", await factorycontract.getPair(NexusToken, xUSDC))
  // console.log("NEXU / xUSDT:", await factorycontract.getPair(NexusToken, xUSDT))
  // console.log("NEXU / xdc:", await factorycontract.getPair(NexusToken, weth9))
  // console.log("NEXU / WAN:", await factorycontract.getPair(NexusToken, WAN))
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

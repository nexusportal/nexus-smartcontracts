import {ethers} from "hardhat";
export const PERMIT_TYPEHASH = ethers.utils.keccak256(
  ethers.utils.toUtf8Bytes('Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)')
)
import * as dotenv from "dotenv";

import { HardhatUserConfig } from "hardhat/config";
import "@nomiclabs/hardhat-etherscan";
import "@nomiclabs/hardhat-ethers";
import "hardhat-gas-reporter";
import "@nomicfoundation/hardhat-chai-matchers";
import "hardhat-contract-sizer";

dotenv.config();

const pk = process.env.PK;
if (!pk) throw new Error("!pk");

const config: HardhatUserConfig = {
  solidity: {
    version: "0.8.12",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200,
      },
    },
  },
  networks: {
    hardhat: {
      chainId: 1337,
      forking: {
        enabled: true,
        blockNumber: undefined,
        url: 'https://erpc.apothem.network',
      }
    },
    xinfin: {
      url: process.env.RPCURL,
      accounts: [pk],
    }
  },
  etherscan: {
    apiKey: {
      xinfin: process.env.ETHERSCAN_API_KEY || ""
    },
    customChains: [
      {
        network: "apothem",
        chainId: 51,
        urls: {
          apiURL: "https://rpc.apothem.network",
          browserURL: "https://explorer.apothem.network/",
        },
      }
    ],
  },
  gasReporter: {
    currency: "CHF",
    gasPrice: 21,
  },
  mocha: {
    timeout: 100000,
  },
  contractSizer: {
    alphaSort: true,
    disambiguatePaths: false,
    runOnCompile: true,
    strict: true,
    // only: [':ERC20$'],
  }
};

export default config;

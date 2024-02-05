import * as dotenv from "dotenv";

import { HardhatUserConfig, task } from "hardhat/config";
import "@nomiclabs/hardhat-etherscan";
import "@nomiclabs/hardhat-ethers";
import "hardhat-gas-reporter";
import "@nomicfoundation/hardhat-chai-matchers";
import "hardhat-contract-sizer";

dotenv.config();

task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
  const accounts = await hre.ethers.getSigners();

  for (const account of accounts) {
    console.log(account.address);
  }
});

interface CustomUserConfig extends HardhatUserConfig {
  namedAccounts: any
}

const pk = process.env.PK;
if (!pk) throw new Error("!pk");

const config = {
  solidity: {
    version: "0.8.12",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200,
      },
    },
  },
  namedAccounts: {
    deployer: 0,
    minter: 1,
    owner0: 5,
    owner1: 2,
    owner2: 3,
    owner3: 4
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
    apothem: {
      url: process.env.RPCURL,
      accounts: [pk],
    },
    xrp_evm: {
      url: "https://rpc-evm-sidechain.xrpl.org",
      accounts: [pk],
    },
  },
  etherscan: {
    apiKey: {
      apothem: process.env.ETHERSCAN_API_KEY || "",
      xrp_evm: process.env.ETHERSCAN_API_KEY || ""
    },
    customChains: [
      {
        network: "apothem",
        chainId: 51,
        urls: {
          apiURL: "https://rpc.apothem.network",
          browserURL: "https://explorer.apothem.network/",
        },
      },
      {
        network: "xrp_evm",
        chainId: 1440002,
        urls: {
          apiURL: "https://rpc-evm-sidechain.xrpl.org",
          browserURL: "https://evm-sidechain.xrpl.org/",
        },
      },

    ],
  },
  // gasReporter: {
  //   currency: "CHF",
  //   gasPrice: 21,
  // },
  mocha: {
    timeout: 100000,
  },
  // contractSizer: {
  //   alphaSort: true,
  //   disambiguatePaths: false,
  //   runOnCompile: true,
  //   strict: true,
  //   // only: [':ERC20$'],
  // }
};

export default config;

import * as dotenv from "dotenv";

import { HardhatUserConfig, task } from "hardhat/config";
import "@nomiclabs/hardhat-etherscan";
import "@nomiclabs/hardhat-ethers";
import "hardhat-gas-reporter";
import "@nomicfoundation/hardhat-chai-matchers";
import "hardhat-contract-sizer";

dotenv.config();

task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
  const accounts = await (hre as any).ethers.getSigners();

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
    xdc: {
      url: process.env.MAIN_RPCURL,
      accounts: [pk],
    },
    xrp_evm_mainnet: {
      url: "https://rpc.xrplevm.org",
      chainId: 1440000,
      accounts: [pk],
      // Remove fixed gasPrice to use dynamic pricing
      gas: 8000000,
    },
    xrp_evm_testnet: {
      url: "https://rpc-evm-sidechain.xrpl.org",
      chainId: 1440002,
      accounts: [pk],
      gasPrice: 6000000000, // 6 gwei (consistent with mainnet)
      gas: 8000000,
    },
    // Keep old xrp_evm for backwards compatibility
    xrp_evm: {
      url: "https://rpc.xrplevm.org", // Fixed: was pointing to testnet
      chainId: 1440000, // Fixed: was 1440002 (testnet)
      accounts: [pk],
    },
  },
  etherscan: {
    apiKey: {
      apothem: process.env.ETHERSCAN_API_KEY || "",
      xdc: process.env.ETHERSCAN_API_KEY || "",
      xrp_evm_mainnet: "dummy", // XRP EVM doesn't need API key
      xrp_evm_testnet: "dummy", // XRP EVM doesn't need API key
      xrp_evm: "dummy" // XRP EVM doesn't need API key
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
        network: "xdc",
        chainId: 50,
        urls: {
          apiURL: process.env.MAIN_RPCURL,
          browserURL: "https://xdc.network/",
        },
      },
      {
        network: "xrp_evm_mainnet",
        chainId: 1440000,
        urls: {
          apiURL: "https://explorer.xrplevm.org/api",
          browserURL: "https://explorer.xrplevm.org/",
        },
      },
      {
        network: "xrp_evm_testnet",
        chainId: 1440002,
        urls: {
          apiURL: "https://evm-sidechain.xrpl.org/api",
          browserURL: "https://evm-sidechain.xrpl.org/",
        },
      },
      {
        network: "xrp_evm",
        chainId: 1440000,
        urls: {
          apiURL: "https://explorer.xrplevm.org/api",
          browserURL: "https://explorer.xrplevm.org/",
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

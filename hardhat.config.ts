import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox-viem";
import * as dotenv from 'dotenv';

dotenv.config();

const accounts = {
  mnemonic:
    process.env.MNEMONIC ||
    'test test test test test test test test test test test junk',
};

const config: HardhatUserConfig = {
  solidity: "0.8.0",
  defaultNetwork: "bsc-testnet",
  networks: {
    mainnet: {
      url: 'https://mainnet.era.zksync.io',
      accounts,
      chainId: 324,
    },
    'bsc-testnet': {
      url: 'https://data-seed-prebsc-1-s1.binance.org:8545/',
      accounts,
      chainId: 97,
    },
    hardhat: {
      forking: {
        enabled: process.env.FORKING === 'true',
        url: 'https://mainnet.era.zksync.io',
      },
    },
  },
};

export default config;

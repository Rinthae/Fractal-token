< uyqead-codex/crear-contrato-solidity-revenuesplitter
require("@nomiclabs/hardhat-ethers");

module.exports = {
  solidity: "0.8.20",
  networks: {
    mumbai: {
      url: process.env.MUMBAI_RPC_URL || "",
      accounts: process.env.PRIVATE_KEY ? [process.env.PRIVATE_KEY] : [],
    },
  },

< o82cie-codex/crear-contrato-solidity-revenuesplitter
require('dotenv').config();
require('@nomiclabs/hardhat-ethers');
require('@nomiclabs/hardhat-etherscan');

const INFURA_ID = process.env.INFURA_ID;
const PRIVATE_KEY = process.env.PRIVATE_KEY;

module.exports = {
  solidity: '0.8.20',
  networks: {
    polygon: {
      url: `https://polygon-mainnet.infura.io/v3/${INFURA_ID}`,
      accounts: PRIVATE_KEY ? [PRIVATE_KEY] : [],
      chainId: 137,
    },
  },
  etherscan: {
    apiKey: process.env.POLYGONSCAN_API_KEY,
  },

require("@nomicfoundation/hardhat-toolbox");
module.exports = {
  solidity: "0.8.20",
 main
 main
};

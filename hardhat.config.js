require('dotenv').config();
require('@nomicfoundation/hardhat-toolbox');

const { PRIVATE_KEY, MUMBAI_RPC_URL, POLYGON_RPC_URL, POLYGONSCAN_API_KEY } = process.env;

module.exports = {
  solidity: '0.8.20',
  networks: {
    mumbai: {
      url: MUMBAI_RPC_URL || '',
      accounts: PRIVATE_KEY ? [PRIVATE_KEY] : [],
    },
    polygon: {
      url: POLYGON_RPC_URL || '',
      accounts: PRIVATE_KEY ? [PRIVATE_KEY] : [],
      chainId: 137,
    },
  },
  etherscan: {
    apiKey: POLYGONSCAN_API_KEY || '',
  },
};

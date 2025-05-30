import { ethers } from 'ethers';

// Replace with deployed addresses on Mumbai
export const FRACTAL_TOKEN_ADDRESS = '0x0000000000000000000000000000000000000000';
export const TOKEN_ESCROW_ADDRESS = '0x0000000000000000000000000000000000000000';
export const INVESTOR_REGISTRY_ADDRESS = '0x0000000000000000000000000000000000000000';
export const REVENUE_SPLITTER_ADDRESS = '0x0000000000000000000000000000000000000000';

export const fractalTokenAbi = [
  'function balanceOf(address) view returns (uint256)',
  'function approve(address,uint256) returns (bool)'
];

export const tokenEscrowAbi = [
  'function lockTokens(address,uint256,uint256)',
  'function unlockTokens(address)'
];

export const investorRegistryAbi = [
  'function isWhitelisted(address) view returns (bool)',
  'function getInvestorType(address) view returns (uint8)'
];

export const revenueSplitterAbi = [
  'function pendingYield(address) view returns (uint256)',
  'function claimYield()'
];

export const getProvider = () => new ethers.providers.Web3Provider(window.ethereum);

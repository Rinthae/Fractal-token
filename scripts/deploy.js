const hre = require('hardhat');

async function main() {
  const [deployer] = await hre.ethers.getSigners();
  console.log('Deploying contracts with:', deployer.address);

  const Factory = await hre.ethers.getContractFactory('FractalTokenFactory');
  const factory = await Factory.deploy();
  await factory.deployed();
  console.log('FractalTokenFactory deployed to:', factory.address);

  // RevenueSplitter requires a token address; using zero for example
  const RevenueSplitter = await hre.ethers.getContractFactory('RevenueSplitter');
  const revenueSplitter = await RevenueSplitter.deploy(hre.ethers.constants.AddressZero);
  await revenueSplitter.deployed();
  console.log('RevenueSplitter deployed to:', revenueSplitter.address);

  const InvestorRegistry = await hre.ethers.getContractFactory('InvestorRegistry');
  const investorRegistry = await InvestorRegistry.deploy();
  await investorRegistry.deployed();
  console.log('InvestorRegistry deployed to:', investorRegistry.address);

  const TokenEscrow = await hre.ethers.getContractFactory('TokenEscrow');
  const tokenEscrow = await TokenEscrow.deploy();
  await tokenEscrow.deployed();
  console.log('TokenEscrow deployed to:', tokenEscrow.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

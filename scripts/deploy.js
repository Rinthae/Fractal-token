const hre = require('hardhat');

async function main() {
  const [deployer] = await hre.ethers.getSigners();
  console.log('Deploying contracts with:', deployer.address);

  const Factory = await hre.ethers.getContractFactory('FractalTokenFactory');
  const factory = await Factory.deploy();
  await factory.deployed();
  console.log('FractalTokenFactory deployed to:', factory.address);

  const InvestorRegistry = await hre.ethers.getContractFactory('InvestorRegistry');
  const registry = await InvestorRegistry.deploy();
  await registry.deployed();
  console.log('InvestorRegistry deployed to:', registry.address);

  const TokenEscrow = await hre.ethers.getContractFactory('TokenEscrow');
  const escrow = await TokenEscrow.deploy();
  await escrow.deployed();
  console.log('TokenEscrow deployed to:', escrow.address);

  const RevenueSplitter = await hre.ethers.getContractFactory('RevenueSplitter');
  const splitter = await RevenueSplitter.deploy(hre.ethers.constants.AddressZero);
  await splitter.deployed();
  console.log('RevenueSplitter deployed to:', splitter.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

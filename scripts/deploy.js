 uyqead-codex/crear-contrato-solidity-revenuesplitter
async function main() {
  const [deployer] = await ethers.getSigners();
  console.log("Deploying contracts with:", deployer.address);

  const Factory = await ethers.getContractFactory("FractalTokenFactory");
  const factory = await Factory.deploy();
  await factory.deployed();
  console.log("FractalTokenFactory deployed to:", factory.address);

  const InvestorRegistry = await ethers.getContractFactory("InvestorRegistry");
  const registry = await InvestorRegistry.deploy();
  await registry.deployed();
  console.log("InvestorRegistry deployed to:", registry.address);

  const TokenEscrow = await ethers.getContractFactory("TokenEscrow");
  const escrow = await TokenEscrow.deploy();
  await escrow.deployed();
  console.log("TokenEscrow deployed to:", escrow.address);

  const RevenueSplitter = await ethers.getContractFactory("RevenueSplitter");
  // Replace the argument with the address of the FractalToken if required
  const splitter = await RevenueSplitter.deploy(factory.address);
  await splitter.deployed();
  console.log("RevenueSplitter deployed to:", splitter.address);

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
 main
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

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
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

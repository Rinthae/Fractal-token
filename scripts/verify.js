const hre = require("hardhat");

const addresses = {
  FractalTokenFactory: "0x...",
  RevenueSplitter: "0x...",
  InvestorRegistry: "0x...",
  TokenEscrow: "0x..."
};

async function main() {
  for (const [name, address] of Object.entries(addresses)) {
    console.log(`Verifying ${name} at ${address}...`);
    try {
      await hre.run("verify:verify", {
        address,
        constructorArguments: []
      });
      console.log(`${name} verified!`);
    } catch (err) {
      console.error(`Failed to verify ${name}:`, err.message);
    }
  }
}

main()
  .then(() => console.log("Verification script completed."))
  .catch((err) => {
    console.error(err);
    process.exit(1);
  });

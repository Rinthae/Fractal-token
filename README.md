 zoymew-codex/crear-contrato-solidity-revenuesplitter
# Fractal Token Project

This repository contains Solidity contracts for managing fractional real estate tokens and a simple frontend built with Vite and React.

## Contracts

- `RevenueSplitter.sol` – Distributes rental income among token holders.

## Frontend

A basic React interface lives under `frontend/`. It connects to Metamask on the Polygon Mumbai network and interacts with the deployed contracts.

### Install dependencies

```bash
cd frontend
npm install
```

### Run the development server

```bash
npm run dev
```

Update the contract addresses in `src/utils/contract.js` with the ones deployed on Polygon Mumbai.

# Fractal Token

uyqead-codex/crear-contrato-solidity-revenuesplitter
## Deploying Contracts

Install dependencies and run the deployment script on the Mumbai testnet:

```bash
npm install
npx hardhat run scripts/deploy.js --network mumbai
```

<o82cie-codex/crear-contrato-solidity-revenuesplitter
## Deployment
1. Copy `.env.example` to `.env` and fill in your `INFURA_ID`, `PRIVATE_KEY`, and `POLYGONSCAN_API_KEY`.
2. Install dependencies with `npm install --save-dev hardhat @nomiclabs/hardhat-ethers @nomiclabs/hardhat-etherscan dotenv`.
3. Deploy on Polygon mainnet:
   ```bash
   npx hardhat run scripts/deploy.js --network polygon
   ```

### Security
- Make sure `.env` is listed in `.gitignore`.
- Never commit private keys or API keys to version control.

This repository contains Solidity contracts for a fractional real estate token and related utilities.

## Hardhat Setup

Install dependencies:

```bash
npm install
```

Run tests with:

```bash
npx hardhat test
```

 main
 > main
 main

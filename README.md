# Fractal Token

This project contains Solidity contracts for managing fractional real estate tokens and a simple React frontend. The main contract `FractalToken.sol` implements a basic whitelisted token that allows owners to allocate and claim rental yield. `FractalTokenFactory.sol` can deploy new token instances, while `RevenueSplitter.sol` distributes revenue among holders.

## Requirements

- Node.js
- Hardhat

Create a `.env` file based on `.env.example` and fill in your RPC URLs, private key and Polygonscan key.

## Install

```bash
npm install
cd frontend && npm install
```

## Test

Run the contract tests with Hardhat:

```bash
npx hardhat test
```

## Deploy

Deploy the contracts to a network such as Mumbai:

```bash
npx hardhat run scripts/deploy.js --network mumbai
```

## Frontend

Inside `frontend/` run the development server:

```bash
npm run dev
```

Update the contract addresses in `frontend/src/utils/contract.js` with the ones printed on deployment.

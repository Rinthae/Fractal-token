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

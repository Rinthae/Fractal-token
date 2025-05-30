# Fractal Token

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

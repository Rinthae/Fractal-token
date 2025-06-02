import { useEffect, useState } from 'react';
import { ethers } from 'ethers';
import {
  FRACTAL_TOKEN_ADDRESS,
  fractalTokenAbi,
  TOKEN_ESCROW_ADDRESS,
  tokenEscrowAbi,
  INVESTOR_REGISTRY_ADDRESS,
  investorRegistryAbi,
  REVENUE_SPLITTER_ADDRESS,
  revenueSplitterAbi,
} from '../utils/contract';

function Dashboard({ signer, address }) {
  const [balance, setBalance] = useState('0');
  const [yieldRight, setYieldRight] = useState('0');
  const [whitelisted, setWhitelisted] = useState(false);
  const [investorType, setInvestorType] = useState(0);
  const [lockAmount, setLockAmount] = useState('');
  const [lockDuration, setLockDuration] = useState('');

  const token = new ethers.Contract(FRACTAL_TOKEN_ADDRESS, fractalTokenAbi, signer);
  const escrow = new ethers.Contract(TOKEN_ESCROW_ADDRESS, tokenEscrowAbi, signer);
  const registry = new ethers.Contract(INVESTOR_REGISTRY_ADDRESS, investorRegistryAbi, signer);
  const splitter = new ethers.Contract(REVENUE_SPLITTER_ADDRESS, revenueSplitterAbi, signer);

  const loadInfo = async () => {
    const bal = await token.balanceOf(address);
    setBalance(ethers.utils.formatUnits(bal, 18));
    const pending = await splitter.pendingYield(address);
    setYieldRight(ethers.utils.formatEther(pending));
    setWhitelisted(await registry.isWhitelisted(address));
    setInvestorType(await registry.getInvestorType(address));
  };

  useEffect(() => {
    loadInfo();
  }, [address]);

  const claimYield = async () => {
    await splitter.claimYield();
    loadInfo();
  };

  const lockTokens = async () => {
    const amount = ethers.utils.parseUnits(lockAmount || '0', 18);
    await token.approve(TOKEN_ESCROW_ADDRESS, amount);
    await escrow.lockTokens(FRACTAL_TOKEN_ADDRESS, amount, lockDuration);
  };

  const unlockTokens = async () => {
    await escrow.unlockTokens(FRACTAL_TOKEN_ADDRESS);
  };

  return (
    <div>
      <div className="mb-2">Balance: {balance} FRT</div>
      <div className="mb-2">Yield derecho: {yieldRight} ETH</div>
      <button onClick={claimYield} className="bg-green-500 text-white px-2 py-1 rounded mb-4">
        Claim Yield
      </button>
      <div className="mb-2">Whitelisted: {whitelisted ? 'Sí' : 'No'}</div>
      <div className="mb-4">Tipo de inversionista: {investorType}</div>
      <div className="mb-2">
        <input
          value={lockAmount}
          onChange={e => setLockAmount(e.target.value)}
          placeholder="Cantidad"
          className="border p-1 mr-2"
        />
        <input
          value={lockDuration}
          onChange={e => setLockDuration(e.target.value)}
          placeholder="Duración (s)"
          className="border p-1 mr-2"
        />
        <button onClick={lockTokens} className="bg-blue-500 text-white px-2 py-1 rounded">
          Lock Tokens
        </button>
      </div>
      <button onClick={unlockTokens} className="bg-yellow-500 text-white px-2 py-1 rounded">
        Unlock Tokens
      </button>
    </div>
  );
}

export default Dashboard;

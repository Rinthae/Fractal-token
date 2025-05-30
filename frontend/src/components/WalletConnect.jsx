import { useState } from 'react';
import { ethers } from 'ethers';

function WalletConnect({ onConnect, address }) {
  const [connecting, setConnecting] = useState(false);

  const connect = async () => {
    if (!window.ethereum) {
      alert('Instala Metamask');
      return;
    }
    setConnecting(true);
    const provider = new ethers.providers.Web3Provider(window.ethereum);
    await provider.send('eth_requestAccounts', []);
    // Mumbai chainId 80001 -> 0x13881
    const network = await provider.getNetwork();
    if (network.chainId !== 80001) {
      try {
        await provider.send('wallet_switchEthereumChain', [{ chainId: '0x13881' }]);
      } catch (e) {
        console.warn('No se pudo cambiar de red');
      }
    }
    const signer = provider.getSigner();
    const account = await signer.getAddress();
    setConnecting(false);
    onConnect(signer, account);
  };

  return (
    <div className="mb-4">
      {address ? (
        <p className="text-sm">Conectado: {address}</p>
      ) : (
        <button
          onClick={connect}
          disabled={connecting}
          className="bg-blue-500 text-white px-4 py-2 rounded"
        >
          {connecting ? 'Conectando...' : 'Conectar Wallet'}
        </button>
      )}
    </div>
  );
}

export default WalletConnect;

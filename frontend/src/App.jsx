import { useState } from 'react';
import WalletConnect from './components/WalletConnect';
import Dashboard from './components/Dashboard';

function App() {
  const [signer, setSigner] = useState(null);
  const [address, setAddress] = useState('');

  const handleConnect = (providerSigner, account) => {
    setSigner(providerSigner);
    setAddress(account);
  };

  return (
    <div className="max-w-xl mx-auto p-4">
      <h1 className="text-2xl font-bold mb-4">Fractal Dashboard</h1>
      <WalletConnect onConnect={handleConnect} address={address} />
      {signer && <Dashboard signer={signer} address={address} />}
    </div>
  );
}

export default App;

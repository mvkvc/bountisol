import React, { useMemo } from "react";
import { WalletAdapterNetwork } from "@solana/wallet-adapter-base";
import {
  WalletModalProvider,
  WalletMultiButton
} from "@solana/wallet-adapter-react-ui";
import {
  ConnectionProvider,
  WalletProvider,
} from "@solana/wallet-adapter-react";
// import { WalletConnectWalletAdapter } from "@solana/wallet-adapter-walletconnect";
// import { SolflareWalletAdapter } from "@solana/wallet-adapter-solflare";
import { clusterApiUrl } from "@solana/web3.js";

import WalletHandler from "./WalletHandler";

interface WalletAdapterProps {
  network_type: string;
  pushEventTo: (id: string, message: string) => void;
  handleEvent: (event: any) => void;
}

const WalletAdapter: React.FC<WalletAdapterProps> = ({ network_type, pushEventTo, handleEvent }) => {
  const network =
    network_type === "main"
      ? WalletAdapterNetwork.Mainnet
      : WalletAdapterNetwork.Devnet;
  const endpoint = useMemo(() => clusterApiUrl(network), [network]);
  const wallets = useMemo(() => [
    // new WalletConnectWalletAdapter();
    // new SolflareWalletAdapter()
  ], [network]);

  return (
    <ConnectionProvider endpoint={endpoint}>
      <WalletProvider wallets={wallets} autoConnect>
        <WalletModalProvider>
          <div className="flex space-x-4">
            <WalletMultiButton />
            <WalletHandler pushEventTo={pushEventTo} handleEvent={handleEvent} />
          </div>
        </WalletModalProvider>
      </WalletProvider>
    </ConnectionProvider>
  );
};

export default WalletAdapter;

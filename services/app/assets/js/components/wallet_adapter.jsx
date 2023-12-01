import React, { useMemo } from "react";
import { WalletAdapterNetwork } from "@solana/wallet-adapter-base";
import {
  WalletModalProvider,
  // WalletDisconnectButton,
  WalletMultiButton,
} from "@solana/wallet-adapter-react-ui";
import {
  ConnectionProvider,
  WalletProvider,
} from "@solana/wallet-adapter-react";
import { WalletConnectWalletAdapter } from "@solana/wallet-adapter-walletconnect";
import { SolflareWalletAdapter } from "@solana/wallet-adapter-solflare";
import { clusterApiUrl } from "@solana/web3.js";
import WalletHandler from "./wallet_handler";


const WalletAdapter = ({ network_type, pushEventTo, handleEvent }) => {
  const network =
    network_type === "main"
      ? WalletAdapterNetwork.Mainnet
      : WalletAdapterNetwork.Testnet;
  const endpoint = useMemo(() => clusterApiUrl(network), [network]);
  const wallets = useMemo(() => [
    new WalletConnectWalletAdapter(),
    new SolflareWalletAdapter()
  ], [network]);

  return (
    <ConnectionProvider endpoint={endpoint}>
      <WalletProvider wallets={wallets} autoConnect>
        <WalletModalProvider>
          <div className="flex space-x-4">
            <WalletEvents pushEventTo={pushEventTo} handleEvent={handleEvent} />
            <WalletMultiButton />
            {/* <WalletDisconnectButton /> */}
            {/* Custom components here if needed */}
          </div>
        </WalletModalProvider>
      </WalletProvider>
    </ConnectionProvider>
  );
};

export default WalletAdapter;

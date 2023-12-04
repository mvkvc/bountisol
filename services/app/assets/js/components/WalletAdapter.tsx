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
import { WalletConnectWalletAdapter, WalletConnectWalletAdapterConfig } from "@solana/wallet-adapter-walletconnect";
import { SolflareWalletAdapter, SolflareWalletAdapterConfig } from "@solana/wallet-adapter-solflare";
import { clusterApiUrl } from "@solana/web3.js";

import WalletEffectHandler from "./WalletEffectHandler";

interface window {
  solana: any;
}

interface WalletAdapterProps {
  network_type: string;
  pushEvent: (event: string, payload: any) => void;
  pushEventTo: (target: string, event: string, payload: any) => void;
}

const WalletAdapter: React.FC<WalletAdapterProps> = ({ network_type, pushEvent, pushEventTo }) => {
  const network =
    network_type === "main"
      ? WalletAdapterNetwork.Mainnet
      : WalletAdapterNetwork.Devnet;

  const endpoint = useMemo(() => clusterApiUrl(network), [network]);
  const walletConnectConfig: WalletConnectWalletAdapterConfig = {
    network: network,
    options: {},
  };
  const solflareWalletConfig: SolflareWalletAdapterConfig = {};
  const wallets = useMemo(() => [
    new WalletConnectWalletAdapter(walletConnectConfig),
    new SolflareWalletAdapter(solflareWalletConfig)
  ], [network]);

  return (
  <ConnectionProvider endpoint={endpoint}>
    <WalletProvider wallets={wallets} autoConnect>
      <WalletModalProvider>
        <WalletMultiButton />
        <WalletEffectHandler pushEvent={pushEvent} pushEventTo={pushEventTo} />
      </WalletModalProvider>
    </WalletProvider>
  </ConnectionProvider>
);
};

export default WalletAdapter;

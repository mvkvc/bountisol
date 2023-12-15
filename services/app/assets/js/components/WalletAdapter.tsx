import React, { useMemo } from "react";
import { WalletAdapterNetwork } from "@solana/wallet-adapter-base";
import {
  WalletModalProvider,
  WalletMultiButton,
} from "@solana/wallet-adapter-react-ui";
import {
  ConnectionProvider,
  WalletProvider,
} from "@solana/wallet-adapter-react";
// import {
//   WalletConnectWalletAdapter,
//   WalletConnectWalletAdapterConfig,
// } from "@solana/wallet-adapter-walletconnect";
import { SolflareWalletAdapter } from "@solana/wallet-adapter-solflare";
import { clusterApiUrl } from "@solana/web3.js";

import WalletEffectHandler from "./WalletEffectHandler";

interface WalletAdapterProps {
  network_type: string;
  pushEvent: () => void;
  pushEventTo: () => void;
}

const WalletAdapter: React.FC<WalletAdapterProps> = ({
  network_type,
  pushEvent,
  pushEventTo,
}) => {
  const network =
    network_type === "main"
      ? WalletAdapterNetwork.Mainnet
      : WalletAdapterNetwork.Devnet;

  const endpoint = useMemo(() => clusterApiUrl(network), [network]);
  // const walletConnectConfig: WalletConnectWalletAdapterConfig = {
  //   network: network,
  //   options: {},
  // };
  const wallets = useMemo(
    () => [
      // Phantom included in default
      new SolflareWalletAdapter(),
      // new WalletConnectWalletAdapter(walletConnectConfig),
    ],
    [network],
  );

  return (
    <ConnectionProvider endpoint={endpoint}>
      <WalletProvider wallets={wallets} autoConnect>
        <WalletModalProvider>
          <WalletMultiButton />
          <WalletEffectHandler
            pushEvent={pushEvent}
            pushEventTo={pushEventTo}
          />
        </WalletModalProvider>
      </WalletProvider>
    </ConnectionProvider>
  );
};

export default WalletAdapter;

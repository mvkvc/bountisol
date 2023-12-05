import { useEffect } from "react";
import { useWallet } from "@solana/wallet-adapter-react";

const WalletEffectHandler = ({ pushEvent, pushEventTo }) => {
  const { publicKey, connected, disconnecting } = useWallet();

  useEffect(() => {
    if (publicKey) {
      pushEventTo("#wallet-adapter", "effect_public_key", {
        public_key: publicKey.toString(),
      });
    }
  }, [publicKey, pushEventTo]);

  useEffect(() => {
    if (connected) {
      pushEventTo("#wallet-adapter", "effect_connected", {});
    }

    if (disconnecting) {
      pushEventTo("#wallet-adapter", "effect_disconnecting", {});
    }
  }, [connected, disconnecting, pushEventTo]);

  return null;
};

export default WalletEffectHandler;

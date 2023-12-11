import { useEffect } from "react";
import { useWallet } from "@solana/wallet-adapter-react";

interface WalletEffectHandlerProps {
  pushEvent: () => void;
  pushEventTo: (selector: string, eventName: string, detail?: Object) => void;
}

const WalletEffectHandler: React.FC<WalletEffectHandlerProps> = ({ pushEvent, pushEventTo }) => {
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

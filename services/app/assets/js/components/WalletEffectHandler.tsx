import { useEffect } from "react";
import { useWallet } from "@solana/wallet-adapter-react";

interface WalletEffectHandlerProps {
  pushEvent: () => void;
  pushEventTo: (selector: string, eventName: string, detail?: Object) => void;
}

const WalletEffectHandler: React.FC<WalletEffectHandlerProps> = ({
  pushEvent,
  pushEventTo,
}) => {
  const { wallet, publicKey, connected, disconnecting } = useWallet();

  useEffect(() => {
    if (publicKey) {
      pushEventTo("#wallet-adapter", "effect_public_key", {
        public_key: publicKey.toString(),
      });
    }
  }, [publicKey, pushEventTo]);

  useEffect(() => {
    if (connected && wallet) {
      const wallet_name = wallet.adapter.name.toLowerCase()
      console.log(wallet_name)
      pushEventTo("#wallet-adapter", "effect_connected", {"wallet": wallet_name});
    }

    if (disconnecting) {
      pushEventTo("#wallet-adapter", "effect_disconnecting", {});
    }
  }, [wallet, connected, disconnecting, pushEventTo]);

  return null;
};

export default WalletEffectHandler;

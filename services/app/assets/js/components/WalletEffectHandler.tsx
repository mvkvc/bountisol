import { useEffect, useState } from "react";
import {
  useWallet,
} from "@solana/wallet-adapter-react";

interface WalletHandlerProps {
  pushEvent: (event: string, payload: any) => void;
  pushEventTo: (target: string, event: string, payload: any) => void;
}

const WalletEffectHandler: React.FC<WalletHandlerProps> = ({ pushEvent, pushEventTo }) => {
    const { publicKey, connected, disconnecting } = useWallet();
  
    useEffect(() => {
      if (publicKey) {
        // @ts-ignore
        pushEventTo("#wallet-adapter", "effect_public_key", {"public_key": publicKey.toString()})
      } 
    }, [publicKey]);

    useEffect(() => {
      if (connected) {
        // @ts-ignore
        pushEventTo("#wallet-adapter", "effect_connected", {});
      }

      if (disconnecting) {
        // @ts-ignore
        pushEventTo("#wallet-adapter", "effect_disconnecting", {});
      }
    }, [connected, disconnecting]);
  
    return null;
  }
  
export default WalletEffectHandler;

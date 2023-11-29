import { useEffect, useState } from "react";
import {
  useWallet,
} from "@solana/wallet-adapter-react";

// Listen for events from LiveView and handle

const WalletEvents = ({ pushEventTo, handleEvent }) => {
    const { publicKey } = useWallet();
    const [hasConnected, setHasConnected] = useState(false)
  
    useEffect(() => {
      if (publicKey) {
        setHasConnected(true);
          console.log("connected");
          pushEventTo("#wallet", "connected");
      } else {
        if (hasConnected) {
          console.log("disconnected");
          pushEventTo("#wallet", "disconnected");
          setHasConnected(false);
        }
    }}, [publicKey]);
  
    return null;
  }
  
export default WalletEvents;

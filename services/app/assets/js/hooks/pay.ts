import { sendPayment } from "../utils/payments";
import { PublicKey, Transaction } from "@solana/web3.js";

interface EventDetail {
  network_url: string;
  to_address: string;
  amount_sol: number;
  fee_pct: number;
  fee_address: string;
}

interface PhantomProvider {
  publicKey: PublicKey;
  solana: any;
  isPhantom: boolean;
}

const getProvider = (): PhantomProvider | undefined => {
  if ("phantom" in window) {
    const provider = (window as any).phantom?.solana;

    if (provider?.isPhantom) {
      return provider;
    }
  }

  console.error("No provider found (try installing Phantom wallet).");
};

export const Pay = {
  mounted() {
    window.addEventListener("phx:send-payment", async (e: CustomEvent<EventDetail>) => {
      const { network_url, to_address, amount_sol, fee_pct, fee_address } = e.detail;

      try {
        const provider = getProvider();
        if (!provider || !provider.publicKey) throw new Error("Provider not found or invalid public key");

        const tx: Transaction = await sendPayment(
          provider,
          network_url,
          provider.publicKey,
          new PublicKey(to_address),
          new PublicKey(fee_address),
          amount_sol,
          fee_pct
        );

        this.pushEventTo("#send-payment", "payment-sent", { tx });
      } catch (e) {
        console.error("Error sending payment:", e);
      }
    });
  },
  pushEventTo(selector: string, eventName: string, detail: object) {
    // Implementation for pushEventTo
  }
};

export default Pay;

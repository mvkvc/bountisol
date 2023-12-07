import { sendPayment } from "../utils/payments";
import { PublicKey } from "@solana/web3.js";

export const Pay = {
  mounted() {
    const provider = getProvider();

    window.addEventListener(`phx:send-payment`, async (e) => {
      const network_url = e.detail.network_url;
      const to_address = e.detail.to_address;
      const amount_sol = e.detail.amount_sol;
      const fee_pct = e.detail.fee_pct;
      const fee_address = e.detail.fee_address;

      try {
        const tx = await sendPayment(
          provider,
          network_url,
          provider.publicKey,
          new PublicKey(to_address),
          new PublicKey(fee_address),
          amount_sol,
          fee_pct,
        );

        this.pushEventTo("#send-payment", "payment-sent", {
          tx: tx,
        });
      } catch (e) {
        console.error("Error sending payment:", e);
      }
    });
  },
};

const getProvider = () => {
  if ("phantom" in window) {
    const provider = window.phantom?.solana;

    if (provider?.isPhantom) {
      return provider;
    }
  }

  console.error("No provider found (try installing Phantom wallet).");
};

export default Pay;

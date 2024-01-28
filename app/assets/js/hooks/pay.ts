import { PublicKey } from "@solana/web3.js";
import { getProvider, sendPayment } from "../utils/walletUtils";

export const Pay = {
  mounted() {
    let provider: any;

    window.addEventListener("phx:send-payment", async (e: any) => {
      const { network_url, to_address, amount_sol, fee_pct, fee_address } =
        e.detail;

      provider = await getProvider();

      try {
        const signature = await sendPayment(
          provider,
          network_url,
          provider.publicKey,
          new PublicKey(to_address),
          new PublicKey(fee_address),
          amount_sol,
          fee_pct,
        );
        (this as any).pushEventTo("#send-payment", "payment-sent", signature);
      } catch (e: any) {
        console.error(e);
      }
    });
  }
};

export default Pay;

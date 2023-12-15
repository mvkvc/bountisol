import { Header, Payload, SIWS } from "@web3auth/sign-in-with-solana";
import { PublicKey, Transaction } from "@solana/web3.js";
import { getAndConnectProvider, sendPayment } from "../utils/wallet";

function createSolanaMessage(
  address: string,
  statement: string,
  nonce: string,
): SIWS {
  try {
    const domain = window.location.host;
    const origin = window.location.origin;

    const header = new Header();
    header.t = "sip99";
    const payload = new Payload();
    payload.domain = domain;
    payload.uri = origin;
    payload.address = address;
    payload.statement = statement;
    payload.nonce = nonce;
    payload.version = "1";
    payload.chainId = 1;

    return new SIWS({ header, payload });
  } catch (error) {
    console.error("Error creating message:", JSON.stringify(error));
    throw error;
  }
}

let provider: any;

export const Wallet = {
  mounted() {
    window.addEventListener("phx:signature", async (e: any) => {
      const { address, statement, nonce, wallet } = e.detail;

      try {
        provider = await getAndConnectProvider(wallet);
        const message = createSolanaMessage(address, statement, nonce);
        const encodedMessage = new TextEncoder().encode(
          message.prepareMessage(),
        );
        console.log("PROVIDER", provider);
        const signedMessage = await provider.signMessage(
          encodedMessage,
          "utf8",
        );

        (this as any).pushEventTo("#wallet", "verify-signature", {
          message: JSON.stringify(message),
          signature: JSON.stringify(signedMessage),
        });
      } catch (e) {
        console.error("Error signing message:", e);
      }
    });

    window.addEventListener("phx:send-payment", async (e: any) => {
      const { network_url, to_address, amount_sol, fee_pct, fee_address, wallet } =
        e.detail;

      console.log("PROVIDER", provider);

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
      } catch (e) {
        console.error("Error sending payment:", e);
      }
    });
  }
};

export default Wallet;

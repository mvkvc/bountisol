import { createSolanaMessage, getProvider } from "../utils/wallet";
import { Bounty } from "../idl/bounty";
import { getBounty } from "../utils/anchor";

export const Wallet: any = {
  mounted() {
    window.addEventListener("phx:signature", async (e: any) => {
      const { address, statement, nonce } = e.detail;

      try {
        const provider: any = await getProvider();
        const message = createSolanaMessage(address, statement, nonce);
        const encodedMessage = new TextEncoder().encode(
          message.prepareMessage(),
        );
        const signedMessage = await provider.signMessage(
          encodedMessage,
          "utf8",
        );

        (this as any).pushEventTo("#wallet", "verify-signature", {
          message: JSON.stringify(message),
          signature: JSON.stringify(signedMessage.signature.data),
        });
      } catch (e) {
        console.error("Error signing message:", e);
      }
    });

    window.addEventListener("phx:bounty-create", async (e: any) => {
      const {} = e.detail;

      try {
        const bounty: Bounty = getBounty();
        bounty.create();
      } catch (e) {
        console.error("Error:", e);
      }
    });
  },
};

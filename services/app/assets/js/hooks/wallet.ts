import { Header, Payload, SIWS } from "@web3auth/sign-in-with-solana";
import { getProvider } from "../utils/walletUtils";

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

export const Wallet = {
  mounted() {
    window.addEventListener("phx:signature", async (e: any) => {
      const { address, statement, nonce } = e.detail;

      try {
        const provider: any = await getProvider()
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
          signature: JSON.stringify(signedMessage),
        });
      } catch (e) {
        console.error("Error signing message:", e);
      }
    });
  }
};

export default Wallet;

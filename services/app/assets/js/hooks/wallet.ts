import { Header, Payload, SIWS } from "@web3auth/sign-in-with-solana";

interface EventDetail {
  address: string;
  statement: string;
  nonce: string;
}

interface Provider {
  signMessage: (message: Uint8Array, encoding: string) => Promise<Uint8Array>;
}

const getProvider = (): Provider | undefined => {
  if ("phantom" in window) {
    return (window as any).phantom?.solana;
  } else if ("solflare" in window) {
    return (window as any).solana;
  } else {
    console.error("No provider found (try installing Phantom wallet).");
  }
};

function createSolanaMessage(address: string, statement: string, nonce: string): SIWS {
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
    payload.chainId = "1";

    return new SIWS({ header, payload });
  } catch (error) {
    console.error("Error creating message:", JSON.stringify(error));
    throw error;
  }
}

export const Wallet = {
  mounted() {
    window.addEventListener("phx:signature", async (e: CustomEvent<EventDetail>) => {
      const { address, statement, nonce } = e.detail;

      try {
        const provider = getProvider();
        if (!provider) throw new Error("Provider not found");

        const message = createSolanaMessage(address, statement, nonce);
        const encodedMessage = new TextEncoder().encode(message.prepareMessage());
        const signedMessage = await provider.signMessage(encodedMessage, "utf8");

        this.pushEventTo("#wallet", "verify-signature", {
          message: JSON.stringify(message),
          signature: JSON.stringify(signedMessage),
        });
      } catch (e) {
        console.error("Error signing message:", e);
      }
    });
  },
  pushEventTo(selector: string, eventName: string, detail: object) {
    // Implementation for pushEventTo
  }
};

export default Wallet;

import { Header, Payload, SIWS } from "@web3auth/sign-in-with-solana";

export const Wallet = {
  mounted() {
    const provider = getProvider();

    window.addEventListener(`phx:signature`, async (e) => {
      const address = e.detail.address;
      const statement = e.detail.statement;
      const nonce = e.detail.nonce;

      try {
        const message = createSolanaMessage(address, statement, nonce);
        const encodedMessage = new TextEncoder().encode(
          message.prepareMessage(),
        );
        const signedMessage = await provider.signMessage(
          encodedMessage,
          "utf8",
        );

        this.pushEventTo("#wallet", "verify-signature", {
          message: message,
          signedMessage: signedMessage,
        });
      } catch (e) {
        console.error("Error signing message:", e);
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

function createSolanaMessage(address, statement, nonce) {
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

    const message = new SIWS({
      header,
      payload,
    });

    return message;
  } catch (error) {
    console.error("Error creating message:", JSON.stringify(error));
  }
}

export default Wallet;

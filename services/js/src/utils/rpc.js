const { Connection } = require("@solana/web3.js");

function createConnection(network, api_key) {
  if (!api_key) {
    throw new Error("RPC_API_KEY environment variable is not set");
  }

  let url_base;
  switch (network) {
    case "mainnet":
      url_base = "https://mainnet.helius-rpc.com/?api-key=";
      break;
    case "devnet":
      url_base = "https://devnet.helius-rpc.com/?api-key=";
      break;
    default:
      throw new Error(`Unknown network: ${network}`);
  }

  const url = url_base + api_key;
  try {
    const connection = new Connection(url, "confirmed");
    return connection;
  } catch (e) {
    throw new Error(`Error occurred: ${e.message}`);
  }
}

module.exports = createConnection;

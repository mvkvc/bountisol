'use strict'

const fp = require('fastify-plugin');
const { Connection } = require("@solana/web3.js");

module.exports = fp(async function (fastify, opts) {
  fastify.decorate('rpc', function (network = "mainnet") {
    let url_base;
    switch (network) {
      case "mainnet":
        url_base = "https://mainnet.helius-rpc.com/?api-key=";
        break;
      case "devnet":
        url_base = "https://devnet.helius-rpc.com/?api-key=";
        break;
      default:
        throw new Error(`Unknown network: ${network}`);    }

    const api_key = process.env.RPC_API_KEY;
    if (!api_key) {
      throw new Error('RPC_API_KEY environment variable is not set');
    }
    const url = url_base + api_key;

    try {
      const connection = new Connection(url, "confirmed");
      return connection;
    } catch(e) {
      throw new Error(`Failed to connect to ${url}: ${e.message}`);
    }
  });
});

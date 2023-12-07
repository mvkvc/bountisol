const express = require("express");
const { getAllDomains, reverseLookup } = require("@bonfida/spl-name-service");
const { PublicKey } = require("@solana/web3.js");
const rpcClient = require("../utils/rpc");
const Sentry = require("@sentry/node");

async function SNSHandler(req, res) {
  const transaction = Sentry.startTransaction({ name: 'sns' });

  const address = req.params.address;
  const network = process.env.RPC_NETWORK || "mainnet";
  const api_key = process.env.RPC_API_KEY;
  const connection = rpcClient(network, api_key);

  try {
    const ownerWallet = new PublicKey(address);
    const allDomainKeys = await getAllDomains(connection, ownerWallet);
    const allDomainNames = await Promise.all(
      allDomainKeys.map((key) => reverseLookup(connection, key)),
    );
    console.log(`${address} owns the following SNS domains:`);
    allDomainNames.forEach((domain, i) => console.log(` ${i + 1}.`, domain));
    transaction.finish();
    res.json({ domains: allDomainNames });
  } catch (e) {
    console.error("Error occurred:", e.message);
    transaction.finish();
    res.status(400).json({ error: e.message });
  }
}

module.exports = SNSHandler;

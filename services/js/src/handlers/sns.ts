import express, { Request, Response } from "express";
import { getAllDomains,reverseLookup } from "@bonfida/spl-name-service";
import { PublicKey, Connection } from "@solana/web3.js";
import rpcClient from "../utils/rpc";

export default async function (req: Request, res: Response) {
  const address = req.params.address;
  const network = process.env.RPC_NETWORK || "mainnet";
  const api_key = process.env.RPC_API_KEY;
  const connection: Connection = rpcClient(network, api_key);

  try {
    const ownerWallet = new PublicKey(address);
    const allDomainKeys = await getAllDomains(connection, ownerWallet);
    const allDomainNames = await Promise.all(
      allDomainKeys.map((key) => reverseLookup(connection, key)),
    );
    console.log(`${address} owns the following SNS domains:`);
    allDomainNames.forEach((domain, i) => console.log(` ${i + 1}.`, domain));
    res.json({ domains: allDomainNames });
  } catch (e: any) {
    console.error("Error occurred:", e.message);
    res.status(400).json({ error: e.message });
  }
}

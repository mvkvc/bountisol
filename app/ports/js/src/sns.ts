import { getAllDomains, reverseLookup } from "@bonfida/spl-name-service";
import { PublicKey } from "@solana/web3.js";
import createConnection from "./utils/rpc";

export default async function sns(address: string): Promise<string[]> {
  const network = process.env.RPC_NETWORK || "mainnet";
  const api_key = process.env.RPC_API_KEY || "";
  const connection = createConnection(network, api_key);
  const ownerWallet = new PublicKey(address);
  const allDomainKeys = await getAllDomains(connection, ownerWallet);

  return await Promise.all(
    allDomainKeys.map((key) => reverseLookup(connection, key)),
  );
}


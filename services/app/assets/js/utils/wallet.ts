import {
  PublicKey,
  Connection,
  SystemProgram,
  LAMPORTS_PER_SOL,
  Transaction,
  Signer,
} from "@solana/web3.js";

export const getProvider = (name: string) => {
  switch (name) {
    case "phantom": return (window as any).phantom;
    case "solflare": return (window as any).solflare;
    default: console.error("No compatible wallet found (supports Phantom and Solflare).")
  }
};

export const getAndConnectProvider = async (name: string) => {
  const provider = getProvider(name);
  try {
    await provider.connect();
    return provider;
  } catch (e: any) {
      console.error("ERROR: ", e.message);
  }
};

export const sendPayment = async (
  provider: any,
  network_url: string,
  from_pubkey: PublicKey,
  to_pubkey: PublicKey,
  fee_pubkey: PublicKey,
  amount_sol: number,
  fee_pct: number,
): Promise<{ signature: string }> => {
  const connection = new Connection(network_url);
  const amount = Math.ceil(amount_sol * LAMPORTS_PER_SOL);
  const amount_fee = Math.ceil(amount * fee_pct);
  const amount_transfer = amount - amount_fee;

  const instructions = [
    SystemProgram.transfer({
      fromPubkey: from_pubkey,
      toPubkey: fee_pubkey,
      lamports: amount_fee,
    }),
    SystemProgram.transfer({
      fromPubkey: from_pubkey,
      toPubkey: to_pubkey,
      lamports: amount_transfer,
    }),
  ];

  const blockhash = (await connection.getLatestBlockhash("finalized"))
    .blockhash;
  const message = new Transaction({
    recentBlockhash: blockhash,
    feePayer: from_pubkey,
  }).add(...instructions);

  return await provider.signAndSendTransaction(message);
};

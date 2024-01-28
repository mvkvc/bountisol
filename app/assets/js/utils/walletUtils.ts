import {
  PublicKey,
  Connection,
  SystemProgram,
  LAMPORTS_PER_SOL,
  Transaction
} from "@solana/web3.js";

export const getProvider = async () => {
  let provider: any;
  const provider_name = sessionStorage.getItem("_wallet_name");

  if (provider_name == "phantom") {
    provider = (window as any).phantom.solana;
  } else if (provider_name == "solflare") {
    provider = (window as any).solflare;
  } else {
    console.error("No Solana wallet installed.");
  };

  if (provider) {
    if (!provider.isConnected) {
      await provider.connect();
    };
    return provider;
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
) => {
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

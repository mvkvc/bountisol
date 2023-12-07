import {
  Transaction,
  TransactionMessage,
  VersionedTransaction,
  PublicKey,
  Connection,
  SystemProgram,
  LAMPORTS_PER_SOL,
} from "@solana/web3.js";

export const sendPayment = async (
  provider,
  network_url,
  from_pubkey,
  to_pubkey,
  fee_pubkey,
  amount_sol,
  fee_pct,
) => {
  const connection = new Connection(network_url);

  amount = Math.ceil(amount_sol * LAMPORTS_PER_SOL);
  amount_fee = Math.ceil(amount * fee_pct);
  amount_transfer = amount - amount_fee;

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

  let blockhash = (await connection.getLatestBlockhash("finalized")).blockhash;
  console.log("BLOCKHASH");
  console.log(blockhash);

  // console.log("PREPARING MESSAGE");
  // console.log(from_address);
  // console.log(blockhash);
  // console.log(instructions);

  console.log(from_pubkey);
  console.log(blockhash);
  console.log(instructions);

  console.log("PUBKEYTB", from_pubkey.toBase58());
  const messageV0 = new TransactionMessage({
    instructions: instructions,
    payerKey: from_pubkey,
    recentBlockhash: blockhash,
  }).compileToV0Message();

  // make a versioned transaction
  const versionedTransaction = new VersionedTransaction(messageV0);
  return await provider.signAndSendTransaction(versionedTransaction);
};

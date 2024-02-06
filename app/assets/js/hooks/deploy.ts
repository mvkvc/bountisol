import { createSolanaMessage, getConnection, getProvider } from "../utils/wallet";
// import { Bounty } from "../idl/bounty";
import { BN } from "@coral-xyz/anchor";
import { PublicKey, SystemProgram, sendAndConfirmTransaction } from "@solana/web3.js";
import { getBounty } from "../utils/anchor";
import { getTimePlus } from "../utils/time";
import { Sign } from "crypto";

const Deploy = {
  mounted() {
    window.addEventListener("phx:bounty-create", async (e: any) => {
      console.log("phx:bounty-create", e);

      const deadlineWork = getTimePlus(0, 0, 0, 7);
      const deadlineDispute = getTimePlus(0, 0, 0, 14);
      console.log("deadlineWork", deadlineWork);
      console.log("deadlineDispute", deadlineDispute);
      // console.log("this", ((this as any).solana.publicKey));

      // try {
      const bounty = await getBounty();
      const transaction = await bounty.methods.create(
        new BN(deadlineWork),
        new BN(deadlineDispute),
        new PublicKey('UkswKBiSUNr47muqKRhcE5Nas6WFM6zGTHEyfGhZYAs'),
      ).accounts({
        bounty: bounty.programId,
        payer: (this as any).solana.publicKey,
        systemProgram: SystemProgram.programId,
      }).transaction()
      const payerAccount = (this as any).solana.publicKey;

      await sendAndConfirmTransaction(getConnection(), transaction, [payerAccount], {
        commitment: "singleGossip",
        preflightCommitment: "singleGossip",
      });
      // await sendTransaction(transaction, connection)

      // } catch (e) {
      //   console.error("Error:", e);
      // }
    });
  }
};

export default Deploy;

// name: "create";
// accounts: [
//   {
//     name: "bounty";
//     isMut: true;
//     isSigner: false;
//   },
//   {
//     name: "payer";
//     isMut: true;
//     isSigner: true;
//   },
//   {
//     name: "systemProgram";
//     isMut: false;
//     isSigner: false;
//   },
// ];
// args: [
//   {
//     name: "deadlineWork";
//     type: "u64";
//   },
//   {
//     name: "deadlineDispute";
//     type: "u64";
//   },
//   {
//     name: "admin";
//     type: "publicKey";
//   },
// ];

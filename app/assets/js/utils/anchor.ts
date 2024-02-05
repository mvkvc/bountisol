import { Program } from '@coral-xyz/anchor';
import { Connection, PublicKey } from '@solana/web3.js';
import { Bounty } from '../../../../programs/target/types/bounty';
import { IDL } from "../../../../programs/target/idl/bounty.json";
import { getConnection, getProvider } from './wallet';

const PROGRAM_ID_MAINNET = "";

export function getProgramID() {
  return new PublicKey(process.env.PROGRAM_ID ? process.env.PROGRAM_ID : PROGRAM_ID_MAINNET);
}

export function getBounty() {
  return new Program(IDL, getProgramID(), {
    provider: getProvider(),
    connection: getConnection()
  }) as Bounty;
}

// "name": "create",
// "accounts": [
//   {
//     "name": "bounty",
//     "isMut": true,
//     "isSigner": false
//   },
//   {
//     "name": "payer",
//     "isMut": true,
//     "isSigner": true
//   },
//   {
//     "name": "systemProgram",
//     "isMut": false,
//     "isSigner": false
//   }
// ],
// "args": [
//   {
//     "name": "deadlineWork",
//     "type": "u64"
//   },
//   {
//     "name": "deadlineDispute",
//     "type": "u64"
//   },
//   {
//     "name": "admin",
//     "type": "publicKey"
//   }
// ]
// },

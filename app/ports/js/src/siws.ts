import { SIWS } from "@web3auth/sign-in-with-solana";
import bs58 from "bs58";

export default async function siws(header: any, payload: any, _signature: any): Promise<boolean> {
  const signature_data = Uint8Array.from(Buffer.from(_signature.data));

  const signature = {
    t: "sip99",
    s: bs58.encode(signature_data)
  };

  const msg = new SIWS({ header, payload });
  const resp = await msg.verify({ payload, signature });

  return resp.success;
};

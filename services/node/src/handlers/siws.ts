import express, { Request, Response } from "express";
import { SIWS } from "@web3auth/sign-in-with-solana";
import bs58 from "bs58";
import * as Sentry from "@sentry/node";

interface SIWSSignature {
  signature: {
    data: string[];
  };
}

async function SIWSHandler(req: Request, res: Response): Promise<void> {
  const transaction = Sentry.startTransaction({ name: 'siws' });

  try {
    const message = JSON.parse(req.body.message);
    const header = message.header;
    const payload = message.payload;
    
    const signatureData: SIWSSignature = JSON.parse(req.body.signature);
    const signature_str = Uint8Array.from(Buffer.from(signatureData.signature.data));
    
    const signature = {
      t: "sip99",
      s: bs58.encode(signature_str)
    };

    const msg = new SIWS({ header, payload });
    const resp = await msg.verify({ payload, signature });

    if (resp.success == true) {
      console.log("Signature verified for address: ", payload.address);
      transaction.finish();
      res.status(200).json({ verified: true });
    } else {
      console.log("Signature NOT verified for address: ", payload.address);
      transaction.finish();
      res.status(200).json({ verified: false });
    }
  } catch (e) {
    console.error("Error occurred:", e.message);
    transaction.finish();
    res.status(400).json({ error: e.message });
  }
}

export default SIWSHandler;

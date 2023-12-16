import { Request, Response } from "express";
import { SIWS } from "@web3auth/sign-in-with-solana";
import bs58 from "bs58";

async function SIWSHandler(req: Request, res: Response): Promise<void> {
  try {
    const message = JSON.parse(req.body.message);
    const header = message.header;
    const payload = message.payload;

    const signatureData = JSON.parse(req.body.signature);
    const signature_str = Uint8Array.from(Buffer.from(signatureData.signature.data));

    const signature = {
      t: "sip99",
      s: bs58.encode(signature_str)
    };

    const msg = new SIWS({ header, payload });
    const resp = await msg.verify({ payload, signature });

    if (resp.success == true) {
      console.log("Signature verified for address: ", payload.address);
      res.status(200).json({ verified: true });
    } else {
      console.log("Signature NOT verified for address: ", payload.address);
      res.status(200).json({ verified: false });
    }
  } catch (e: any) {
    console.error("Error occurred:", e.message);
    res.status(400).json({ error: e.message });
  }
}

export default SIWSHandler;

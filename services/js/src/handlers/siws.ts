import express, { Request, Response } from "express";
import { Header, Payload, SIWS } from "@web3auth/sign-in-with-solana";
import bs58 from "bs58";

export default async function (req: Request, res: Response) {
  // console.log(req.body);

  try {
    const header = req.body.message.header;
    // console.log("HEADER", header);

    const payload = req.body.message.payload;
    // console.log("PAYLOAD", payload);

    let signature = req.body.signature;
    // console.log("SIGNATURE", signature);
    signature = {t: "ed25519", s: bs58.encode(signature.data)};

    // signature = bs58.decode(signature);

    const msg = new SIWS({ header, payload });
    const resp = await msg.verify({ payload, signature });

    console.log("RESPONSE", resp);

    if (resp.success == true) {
      res.status(200).json({ verified: true });
    } else {
      res.status(200).json({ verified: false });
    }
  } catch (e: any) {
    console.error("Error occurred:", e.message);
    res.status(400).json({ error: e.message });
  }
}

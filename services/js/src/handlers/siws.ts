import express, { Request, Response } from "express";
import { Header, Payload, SIWS } from "@web3auth/sign-in-with-solana";

export default async function (req: Request, res: Response) {
  try {
    const header = req.body.header;
    const payload = req.body.payload;
    const signature = req.body.signature;

    const msg = new SIWS({ header, payload });
    const resp = await msg.verify({ payload, signature });

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

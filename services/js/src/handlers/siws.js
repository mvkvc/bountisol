const express = require("express");
const { SIWS } = require("@web3auth/sign-in-with-solana");
const bs58 = require("bs58");
const Sentry = require("@sentry/node");

async function SIWSHandler(req, res) {
  const transaction = Sentry.startTransaction({ name: 'siws' });

  try {
    const message = JSON.parse(req.body.message);
    const header = message.header;
    const payload = message.payload;
    
    let signatureData = JSON.parse(req.body.signature);
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
      console.log("Signature NOT verified for address: ", address);
      transaction.finish();
      res.status(200).json({ verified: false });
    }
  } catch (e) {
    console.error("Error occurred:", e.message);
    transaction.finish();
    res.status(400).json({ error: e.message });
  }
}

module.exports = SIWSHandler;

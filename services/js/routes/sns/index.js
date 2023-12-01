'use strict'

const {getAllDomains, performReverseLookup } = require("@bonfida/spl-name-service");
const { PublicKey, Connection } = require("@solana/web3.js");

module.exports = async function (fastify, opts) {
  fastify.get('/:address', async function (request, reply) {
    const address = request.params.address;
    const connection = fastify.rpc("mainnet");

    try {
      const ownerWallet = new PublicKey(address);
      const allDomainKeys = await getAllDomains(connection, ownerWallet);
      const allDomainNames = await Promise.all(allDomainKeys.map(key=>{return performReverseLookup(connection, key)}));
      console.log(`${address} owns the following SNS domains:`)
      allDomainNames.forEach((domain,i) => console.log(` ${i+1}.`,domain));
      return {"domains": allDomainNames};
    } catch(e) {
      console.log(`Failed to lookup ${address}: ${JSON.stringify(e, null, 4)}`);
      reply.code(400).send({ error: e.message });
    }
  })
}

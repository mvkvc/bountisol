'use strict'

const { SIWS } = require("@web3auth/sign-in-with-solana");

module.exports = async function (fastify, opts) {
  fastify.post('/', async function (request, reply) {
    try {
      const { payload, signature } = request.body;

      const msg = new SIWS({ header: request.headers, payload });
      const resp = await msg.verify({ payload, signature });

      if (resp.success) {
        return reply.code(200).send({verified: true});
      } else {
        return reply.code(200).send({verified: false});
      }
    } catch (error) {
      reply.code(500).send({ verified: false, error: error.message });
    }
  });
}

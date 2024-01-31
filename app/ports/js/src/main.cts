import { z, register, run } from "portboy";
import siws from "./siws";
import sns from "./sns";

const siws_schema = z.object({
    message: z.any(),
    signature: z.any(),
}).strict()

const sns_schema = z.object({
  address: z.string(),
}).strict()

const registry = register([
    {function: siws, schema: siws_schema, async: true},
    {function: sns, schema: sns_schema, async: true}
])

run(registry);

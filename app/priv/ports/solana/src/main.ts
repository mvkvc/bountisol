import { z, register, run } from "portboy";
import siws from "./siws";
import sns from "./sns";

const siws_schema = z.object({
    header: z.string(),
    payload: z.string(),
    _signature: z.string()
}).strict()

const sns_schema = z.object({
  address: z.string(),
}).strict()

const registry = register([
    {function: siws, schema: siws_schema},
    {function: sns, schema: sns_schema}
])

run(registry);

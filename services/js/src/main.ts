import express, { Express, Request, Response } from "express";

import siwsHandler from "./handlers/siws";
import snsHandler from "./handlers/sns";

const app: Express = express();
const port = process.env.PORT || "3000";

app.get("/sns/:address", snsHandler);
app.post("/siws", siwsHandler);

app.listen(port, () => {
  console.log(`⚡️[server]: Server is running at http://localhost:${port}`);
});

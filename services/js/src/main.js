const express = require("express");

const siwsHandler = require("./handlers/siws");
const snsHandler = require("./handlers/sns");

const app = express();
const port = process.env.PORT || "3000";

app.use(express.json());

app.get("/", (req, res) => {
  res.send("sneaky sneaky");
});
app.get("/sns/:address", snsHandler);
app.post("/siws", siwsHandler);

app.listen(port, () => {
  console.log(`⚡️[server]: Server is running at http://localhost:${port}`);
});

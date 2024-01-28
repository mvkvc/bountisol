import express from "express";
import siwsHandler from "./siws";
import snsHandler from "./sns";

const app = express();
const port = process.env.PORT || "3000";

app.use(express.json());

app.get("/sns/:address", snsHandler);
app.post("/siws", siwsHandler);

app.listen(port, () => {
  console.log(`⚡️[server]: Server is running at http://localhost:${port}`);
});

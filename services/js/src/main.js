const Sentry =require("@sentry/node");
const ProfilingIntegration = require("@sentry/profiling-node").ProfilingIntegration;
const express = require("express");
const siwsHandler = require("./handlers/siws");
const snsHandler = require("./handlers/sns");

Sentry.init({
  dsn: process.env.SENTRY_URL,
  integrations: [
    new ProfilingIntegration(),
  ],
  tracesSampleRate: 1.0,
  profilesSampleRate: 1.0,
});

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

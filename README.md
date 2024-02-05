# bountisol

[![deploy_app](https://github.com/mvkvc/bountisol/actions/workflows/deploy_app.yml/badge.svg)](https://github.com/mvkvc/bountisol/actions/workflows/deploy_app.yml)
[![deploy_inference](https://github.com/mvkvc/bountisol/actions/workflows/deploy_inference.yml/badge.svg)](https://github.com/mvkvc/bountisol/actions/workflows/deploy_inference.yml)

Fully on-chain bounties with fast and cheap payments using Solana.

## Links

- https://bounti.sol
- https://bountisol.xyz
- https://bountisol-app.fly.dev

## Components

- `app/`: Full-stack web application.
- `dataset`: LLM training dataset creation.
- `frame`: Farcaster Frame service.
- `inference/`: LLM inference service.
- `model/`: LLM training.
- `programs/`: Solana programs.
- `sh/`: Shell scripts.

## Developing

### Requirements

- [Nix](https://nixos.org/download.html) (w/ [flakes](https://nixos.wiki/wiki/Flakes) enabled)

### Setup

- Copy `.env.*_` files to `.env.*` and fill in the values.
- Run `nix develop` to enter the Nix shell.
- Run `sh/setup.sh` to install dependencies.

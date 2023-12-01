# akashi

## Links

- https://akashi.systems
- https://app.akashi.systems
- https://github.com/mvkvc/akashi
- https://github.com/users/mvkvc/projects/21
- https://fly.io/dashboard/akashi-systems
- https://supabase.com/dashboard/project/snucvgeeegpsqkhkkazi
- https://dev.helius.xyz/dashboard/app

## Components

- `libs/`: Shared libraries.
- `programs/`: Solana programs.
- `research/`: Incentive research.
- `services/app/`: Main application.
- `services/js/`: Node server for using JS libs.
- `services/site/`: Documentation and blog.

## Development

### Requirements

- [Fly](https://fly.io/docs/hands-on/install-flyctl)
- [Doppler](https://docs.doppler.com/docs/install-cli)
- [Docker](https://docs.docker.com/get-docker/)
- [Nix](https://nixos.org/download.html) (w/ Nix [flakes](https://nixos.wiki/wiki/Flakes) enabled)

### Setup

- Run `doppler login` to authenticate with Doppler.
- Run `sh/secrets.sh` to download development secrets from Doppler.
- Run `nix develop` to enter the project's Nix shell.
- Run `sh/setup.sh` to install dependencies.

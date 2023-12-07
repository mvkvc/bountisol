# akashi

<div align="center">
    <p>Work with everyone, everywhere.</p>
    <img src="assets/bridge.jpg" width="50%">
</div>

## Links

- https://akashi.systems
- https://app.akashi.systems
- https://github.com/mvkvc/akashi
- https://github.com/users/mvkvc/projects/21
- https://fly.io/dashboard/akashi-systems
- https://akashi-systems-345904ce.sentry.io/issues/?project=4506352893624320
- https://supabase.com/dashboard/project/snucvgeeegpsqkhkkazi
- https://dev.helius.xyz/dashboard/app
- https://stats.akashi.systems

## Components

- `programs/`: Solana programs.
- `services/app/`: Main application.
- `services/js/`: NodeJS server for using JS libraries.
- `services/site/`: Landing page, documentation, and blog.

## Development

### Requirements

- [Fly](https://fly.io/docs/hands-on/install-flyctl)
- [Doppler](https://docs.doppler.com/docs/install-cli)
- [Docker](https://docs.docker.com/get-docker/)
- [Nix](https://nixos.org/download.html) (w/ Nix [flakes](https://nixos.wiki/wiki/Flakes) enabled)

### Setup

- Run `doppler login` to authenticate with Doppler.
- Run `sh/secrets.sh` to download secrets locally.
- Run `nix develop` to enter the Nix shell.
- Run `sh/setup.sh` to install dependencies.

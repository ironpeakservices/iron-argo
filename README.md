# iron-argo
Secure base image for running Argo tunnel service to connect to Cloudflare servers.

Check it out on [Docker Hub](https://hub.docker.com/r/ironpeakservices/iron-argo)!

## How is this different?
We build from the official cloudflared source code, but additionally:
- an empty scratch container (no shell, unprivileged user, ...) for a tiny attack vector
- hardened Docker Compose file
- max volume size set to 10GB, max memory set to 4GB

## Example
See the `docker.compose` file.

# iron-argo
Secure base image for running Argo tunnel service to connect to Cloudflare servers.

`docker pull ghrcr.io/ironpeakservices/iron-argo:1.0.0`

## How is this different?
We build from the official cloudflared source code, but additionally:
- an empty scratch container (no shell, unprivileged user, ...) for a tiny attack vector
- hardened Docker Compose file
- docker security scanning
- scratch base image instead of distroless, meaning glibc from latest Go

## Example
See the `argo.compose` file.

## Update policy
Updates to the official cloudflared repository are automatically created as a pull request and trigger linting & a docker build.
When those checks complete without errors, a merge into master will trigger a deploy with the same version to packages.
A GitHub release will also be created to notify the GitHub subscribers.

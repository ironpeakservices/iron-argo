FROM golang:1.13.11-alpine3.10 AS builder

# add unprivileged user
RUN adduser -s /bin/true -u 1000 -D -h /app app \
	&& sed -i -r "/^(app|root)/!d" /etc/group /etc/passwd \
	&& sed -i -r 's#^(.*):[^:]*$#\1:/sbin/nologin#' /etc/passwd

# Add prequisites and fetch go cpde
# hadolint ignore=DL3018
RUN apk add --no-cache ca-certificates git gcc build-base

# copy in our cloudflared sources so we can build it
COPY cloudflared /go/src/github.com/cloudflare/cloudflared

# Switch to the working dir
WORKDIR /go/src/github.com/cloudflare/cloudflared/cmd/cloudflared

# Build a statical file
RUN CGO_ENABLED=0 GOOS=linux \
	go build -o /go/bin/app -ldflags '-w -s -extldflags "-static"' \
	/go/src/github.com/cloudflare/cloudflared/cmd/cloudflared

# ---

# Setup our scratch container
FROM scratch

# add-in our unprivileged user
COPY --from=builder /etc/passwd /etc/group /etc/shadow /etc/

# add-in our CA certificates to validate them when connecting to cloudflare
COPY --from=builder /etc/ssl/certs/ /etc/ssl/certs/

# copy our app 
COPY --from=builder /go/bin/app /app

# run as our unprivileged user instead of root
USER app

# run the app
ENTRYPOINT ["/app"]

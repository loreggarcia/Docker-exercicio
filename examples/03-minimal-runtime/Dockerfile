FROM golang:1.24.2-alpine AS builder
WORKDIR /src
COPY go.mod main.go ./
RUN CGO_ENABLED=0 GOOS=linux go build -trimpath -ldflags="-s -w" -o /out/hello .
FROM scratch AS runtime
COPY --from=builder /out/hello /hello
USER 10001:10001
ENTRYPOINT ["/hello"]

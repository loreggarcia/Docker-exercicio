FROM golang:1.24.2-alpine AS builder
WORKDIR /src
COPY go.mod main.go ./
RUN CGO_ENABLED=0 GOOS=linux go build -trimpath -ldflags="-s -w" -o /out/api .
FROM scratch AS runtime
COPY --from=builder /out/api /api
USER 10001:10001
EXPOSE 5000
ENTRYPOINT ["/api"]

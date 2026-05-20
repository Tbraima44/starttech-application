FROM golang:1.25-alpine AS builder
WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -o /server ./cmd/server

FROM alpine:latest

# Install necessary packages
RUN apk --no-cache add ca-certificates curl netcat-openbsd

# Create a non-root user and group
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Create application directory
WORKDIR /app

# Copy binary and entrypoint
COPY --from=builder /server .
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Change ownership to non-root user
RUN chown -R appuser:appgroup /app

# Switch to non-root user
USER appuser

EXPOSE 8080
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

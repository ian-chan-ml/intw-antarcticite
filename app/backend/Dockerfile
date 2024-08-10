# syntax=docker/dockerfile:1

# Build the application from source
FROM golang:1.22 AS build-stage

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY *.go ./

RUN CGO_ENABLED=0 GOOS=linux go build -o /antarcticite

# Run the tests in the container
FROM build-stage AS test-stage
RUN go test -v ./...

# Deploy the application binary into a lean image
FROM alpine:latest AS release-stage

WORKDIR /

COPY --from=build-stage /antarcticite /antarcticite

# Create a non-root user, grant ownership and switch user
RUN adduser -D appuser

RUN chown appuser /antarcticite

USER appuser

# Run application
EXPOSE 8080

ENTRYPOINT ["/antarcticite"]

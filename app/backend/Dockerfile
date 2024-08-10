# syntax=docker/dockerfile:1

# Build the application from source
FROM golang:1.23 AS build-stage

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY *.go ./

RUN CGO_ENABLED=0 GOOS=linux go build -o /antarcticite

# Run the tests in the container
FROM build-stage AS test-stage
RUN go test -v ./...

# Deploy the application binary into a lean image
FROM gcr.io/distroless/base-debian11 AS release-stage

WORKDIR /

COPY --from=build-stage /antarcticite /antarcticite

# Create a non-root user, grant ownership and switch user
RUN useradd -m appuser

RUN chown appuser /antarcticite

USER appuser

# Run application
EXPOSE 8080

ENTRYPOINT ["/antarcticite"]

# Build image from alpine image
FROM golang:alpine AS buildImage

# Environment variables for go build
ENV GO111MODULE=on \
    CGO_ENABLED=0 \
    GOOS=linux \
    GOARCH=amd64

WORKDIR /go/build

# Copy project files to workdir
COPY . .

# Install build-base containgin gcc package for go builds
RUN apk update && apk upgrade
RUN apk add build-base

# Initialize go module 
RUN go mod init

# Download dependencies
RUN go mod tidy
RUN go mod vendor
RUN go mod download

# Test the app or exit on failure
RUN go test || { echo "Test failed, Aborting building image..." 1>&2 ; exit 1; }

# Build the app or exit on failure
RUN go build -o app . || { echo "Building app failed, Aborting building image..." 1>&2 ; exit 1; }

# New empty image for go app binaries
FROM scratch
# Copy app files from build container
COPY --from=buildImage /go/build /

# Expose port 8080
EXPOSE 8080

# Run the app on container start
ENTRYPOINT ["/app"]
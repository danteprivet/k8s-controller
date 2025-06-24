# Kubernetes Controller

A simple Kubernetes controller that monitors deployment changes in a cluster and provides an HTTP API for interacting with them.

## Features

- Tracking deployment events (add, update, delete) in the `default` namespace
- FastHTTP-based HTTP server for API provision
- CLI interface with various commands
- Support for running both inside and outside the cluster
- Configurable logging levels
- Full test coverage

## Requirements

- Go 1.24+
- Kubernetes cluster or access to one
- kubectl and kubeconfig for cluster access
- Docker (for building and running the container)
- Helm (for deploying to Kubernetes)

## Installation

### From Source

```bash
# Clone the repository
git clone https://github.com/danteprivet/k8s-controller.git
cd k8s-controller

# Install dependencies
go mod download

# Build the project
make build
```

### From Docker Image

```bash
docker pull ghcr.io/danteprivet/k8s-controller:latest
```

### From Helm Chart

```bash
helm install k8s-controller ./charts/k8s-controller
```

## Usage

### CLI Commands

#### Running the Server and Informer

```bash
# Run with local kubeconfig
./controller server --kubeconfig ~/.kube/config

# Run with a different port
./controller server --port 9090 --kubeconfig ~/.kube/config

# Run inside a cluster
./controller server --in-cluster

# Run with detailed logging
./controller server --log-level debug --kubeconfig ~/.kube/config
```

#### Viewing Deployments

```bash
# List deployments in the default namespace
./controller list --kubeconfig ~/.kube/config
```

### Docker

```bash
# Run the container with access to kubeconfig
docker run -v ~/.kube:/root/.kube -p 8080:8080 ghcr.io/danteprivet/k8s-controller:latest server --kubeconfig /root/.kube/config
```

## Development

### Project Structure

```
.
├── .github/workflows    # CI/CD configuration
├── charts              # Helm charts for deployment
├── cmd                 # CLI commands
│   ├── go_basic.go     # Basic Go examples
│   ├── list.go         # Command for viewing deployments
│   ├── root.go         # Root CLI command
│   └── server.go       # Command for running the server and informer
├── pkg                 # Library packages
│   ├── informer        # Informer for tracking deployments
│   └── testutil        # Testing utilities
├── Dockerfile          # Docker image configuration
├── Makefile            # Build and test commands
├── go.mod              # Go modules
├── go.sum              # Dependency hashes
└── main.go             # Program entry point
```

### Running Tests

```bash
# Run all tests
make test

# Run tests with coverage
go test -coverprofile=coverage.out ./...
go tool cover -html=coverage.out
```

### Building Docker Image

```bash
make docker-build
```

## CI/CD

The project uses GitHub Actions for automation:

- Building and testing code
- Building Docker image
- Scanning for vulnerabilities using Trivy
- Publishing Docker image to GitHub Container Registry
- Packaging Helm chart

## Configuration

### Command Line Parameters

| Parameter      | Description                                | Default |
|----------------|--------------------------------------------|---------|
| `--log-level`  | Logging level (trace, debug, info, warn, error) | info |
| `--kubeconfig` | Path to kubeconfig file                    | ""      |
| `--port`       | Port for HTTP server                       | 8080    |
| `--in-cluster` | Use in-cluster configuration               | false   |

## License

[MIT](LICENSE)

## Authors

- [danteprivet](https://github.com/danteprivet)
# Kubernetes Controller

A modern Kubernetes controller that monitors deployment changes in a cluster and provides an HTTP API for interacting with them.

## Features

- Tracking deployment events (add, update, delete) in the `default` namespace
- FastHTTP-based HTTP server for API provision
- CLI interface with various commands
- Support for running both inside and outside the cluster
- Configurable logging levels
- Full test coverage
- Metrics for controller monitoring
- Leader election support for high availability

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
./k8s-controller server --kubeconfig ~/.kube/config

# Run with a different port
./k8s-controller server --port 9090 --kubeconfig ~/.kube/config

# Run inside a cluster
./k8s-controller server --in-cluster

# Run with detailed logging
./k8s-controller server --log-level debug --kubeconfig ~/.kube/config

# Run in test mode (without a real cluster)
./k8s-controller server --test-mode
```

#### Viewing Deployments

```bash
# List deployments in the default namespace
./k8s-controller list --kubeconfig ~/.kube/config
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
│   ├── ctrl            # Controller for handling deployments
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
make test-coverage
```

The `test-coverage` command generates the following files:
- `coverage.out`: Raw coverage data that can be used with Go's cover tool
- `coverage.xml`: XML format coverage report for CI/CD systems

You can visualize the coverage report by running:
```bash
go tool cover -html=coverage.out -o coverage.html
```

Current code coverage metrics:
- Overall coverage: 35.8%
- Controller package (pkg/ctrl): 100%
- Informer package (pkg/informer): 56.0%
- Test utilities (pkg/testutil): 1.6%

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
- Generating and analyzing code coverage reports

## Configuration

### Command Line Parameters

| Parameter      | Description                                | Default |
|----------------|--------------------------------------------|---------|
| `--log-level`  | Logging level (trace, debug, info, warn, error) | info |
| `--kubeconfig` | Path to kubeconfig file                    | ""      |
| `--port`       | Port for HTTP server                       | 8080    |
| `--in-cluster` | Use in-cluster configuration               | false   |
| `--test-mode`  | Run in test mode without a real cluster    | false   |
| `--metrics-port` | Port for controller metrics              | 8081    |
| `--enable-leader-election` | Enable leader election         | true    |
| `--leader-election-namespace` | Namespace for leader election | default |

## API Endpoints

| Endpoint      | Method | Description                                |
|---------------|--------|--------------------------------------------|
| `/deployments` | GET   | Get list of deployments in default namespace |
| `/`           | GET   | Welcome message                            |

## Architecture

The controller uses the Kubernetes "controller-runtime" pattern to track changes in Deployment resources. Main components:

1. **Informer** - tracks deployment events in the cluster
2. **Controller** - processes events and performs reconciliation logic
3. **HTTP API** - provides access to deployment information
4. **Metrics** - provides metrics for controller monitoring

## Testing Strategy

The project employs several testing approaches:

1. **Unit Tests** - Testing individual components in isolation
2. **Integration Tests** - Testing interactions between components
3. **Controller Tests** - Testing controller reconciliation logic using envtest
4. **Coverage Analysis** - Tracking code coverage to identify untested areas

The `envtest` package is used to simulate a Kubernetes API server for testing without requiring a real cluster.

## License

[MIT](LICENSE)

## Authors

- [danteprivet](https://github.com/danteprivet)
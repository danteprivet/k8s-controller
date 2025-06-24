k8s-controller Helm Chart
This Helm chart deploys the k8s-controller with configurable image repository and tag.

Usage
Override the image tag to deploy a specific version:

helm install k8s-controller ./charts/k8s-controller \
  --set image.repository=ghcr.io/your-org/k8s-controller \
  --set image.tag=v1.2.3
The image tag is set by CI to the Git tag (if present) or the commit SHA.
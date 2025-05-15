# Service Foundry Builder - Helm Chart

A Helm chart for deploying the Service Foundry Builder as a Kubernetes Job. This chart provides a template for deploying Service Foundry modules using Kubernetes-native jobs and includes configuration for environment variables, secrets, and volume mounts.

## 📦 Features
- Deploy as a Kubernetes Job
- Configurable environment variables
- S3 storage for Docker context
- Support for multi-architecture builds

## 🛠️ Prerequisites
- Kubernetes 1.24+
- Helm 3.11+
- AWS CLI or Azure CLI configured
- Docker installed

## 🚀 Installation

### 1. Add Helm Repository
```bash
helm repo add service-foundry https://nsalexamy.github.io/helm-charts/
helm repo update
```

### 2. Create Namespace
```bash
kubectl create namespace service-foundry
```

### 3. Create aws-secret Secret


```bash
kubectl -n service-foundry create secret generic aws-secret \
  --from-literal=AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID \
  --from-literal=AWS_ACCOUNT_ID=$AWS_ACCOUNT_ID \
  --from-literal=AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY \
  --from-literal=AWS_REGION=$AWS_REGION
```

### 4. Create service-foundry-github-ssh Secret
```bash
kubectl -n service-foundry create secret generic service-foundry-github-ssh --from-file=./id_rsa --from-file=./id_rsa.pub
```

### 5. Create service-foundry-config-files Secret
```bash
kubectl create secret generic service-foundry-config-files \
  --from-file=infra-foundry-config.yaml \
  --from-file=o11y-foundry-config.yaml \
  --from-file=sso-foundry-config.yaml \
  -n service-foundry
```
### 6. Install the Chart
```bash
helm install service-foundry-builder service-foundry/service-foundry-builder \
  --namespace service-foundry \
  --version 0.1.0 \
  

```

## ✅ Uninstalling the Chart
To uninstall the chart:

```bash
helm uninstall service-foundry-builder -n service-foundry
```

## 🛠️ Troubleshooting
- Check pod logs:
  ```bash
  kubectl logs -l app=service-foundry-builder -n service-foundry
  ```
- Verify the Job status:
  ```bash
  kubectl get jobs -n service-foundry
  ```




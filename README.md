# Service Foundry Helm Charts

Service Foundry Builder is a Kubernetes-native tool for building and deploying Service Foundry modules in a cloud-native environment. It leverages containerized builds, Kubernetes Jobs, and popular DevOps tools to streamline the deployment process.


## Helm Charts

- [Service Foundry Builder](service-foundry-builder/README.md): A Helm chart for deploying the Service Foundry Builder.
- [React O11y App](react-o11y-app/README.md): A Helm chart for deploying the React O11y App, which provides a user interface for observability.

## Service Foundry

- [Service Foundry](https://nsalexamy.github.io/service-foundry/): A cloud-native platform for building and deploying turnkey solutions for various use cases such as observability, SSO, Spring Backend, and BigData.


== Scripts

```shell
./push-to-ecr.sh -t 0.1.6
```

```shell
export GITHUB_USER=credemol
export GITHUB_PASSWORD='github-password'
export IMAGE_TAG=0.1.7

./push-to-github.sh -t $IMAGE_TAG -u $GITHUB_USER -p $GITHUB_PASSWORD
```




```shell

#!/bin/bash
set -e

all_charts=(
    "service-foundry-builder"
)

usage() {
  echo ''
  echo ''
  echo "Usage: ${0} [-u github-username] [-p github-password] [-t tag]"
  echo ''
  echo 'options'
  echo '  -u : Github username'
  echo '  -p : Github password'
  echo '  -t : Tag for the docker image and chart version. default is 0.1.0'
  echo '  -h : Display this help message'

  exit 1
}

GITHUB_USERNAME="${GITHUB_USERNAME:-}"
GITHUB_PASSWORD="${GITHUB_PASSWORD:-}"

while getopts "hu:p:t:" OPTION
do
  case ${OPTION} in
    u) GITHUB_USERNAME="${OPTARG}" ;;
    p) GITHUB_PASSWORD="${OPTARG}" ;;
    t) TAG="${OPTARG}" ;;
    h) usage ;;
    ?) usage ;;
  esac
done


# check all arguments are provided
if [ -z "${GITHUB_USERNAME}" ] || [ -z "${GITHUB_PASSWORD}" ] || [ -z "${TAG}" ]; then
  echo "All arguments are required"
  usage
fi

CHART_VERSION="${TAG}"
REPOSITORY="credemol/service-foundry-builder"

for chart in "${all_charts[@]}"; do
  echo "Updating chart version for ${chart} to ${TAG}"
  # if OS is MacOS
  if [[ "$OSTYPE" == "darwin"* ]]; then
    sed -i '' "s/version:.*/version: ${TAG}/" "${chart}/Chart.yaml"
    set -i '' "s/repository:.*/repository: ${REPOSITORY}/" "${chart}/values.yaml"
    sed -i '' "s/tag:.*/tag: ${TAG}/" "${chart}/values.yaml"
  else
    sed -i "s/version:.*/version: ${TAG}/" "${chart}/Chart.yaml"
    sed -i "s/repository:.*/repository: ${REPOSITORY}/" "${chart}/values.yaml"
    sed -i "s/tag:.*/tag: ${TAG}/" "${chart}/values.yaml"
  fi

  helm package ${chart}
  helm repo index . --url https://nsalexamy.github.io/helm-charts

  git add .
  git commit -m "Update ${chart} chart to version $CHART_VERSION"

  git tag -a v${CHART_VERSION} -m "Release version $CHART_VERSION"

  git push origin main
done



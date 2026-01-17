#!/bin/bash
set -e

# all_charts=(
#     "service-foundry-builder"
#     "otel-spring-example"
#     "react-o11y-app"
#     "service-foundry-console"
#     "service-foundry-community"
# )

all_charts=(
    "service-foundry-builder"
    "service-foundry-console"
    "service-foundry-community"
)

usage() {
  echo ''
  echo ''
  echo "Usage: ${0} [-u github-username] [-p github-password] "
  echo ''
  echo 'options'
  echo '  -u : Github username'
  echo '  -p : Github password'
  echo '  -h : Display this help message'

  exit 1
}

GITHUB_USERNAME="${GITHUB_USERNAME:-}"
GITHUB_PASSWORD="${GITHUB_PASSWORD:-}"
#TAG=$(cat current-version.txt)
while getopts "hu:p:" OPTION
do
  case ${OPTION} in
    u) GITHUB_USERNAME="${OPTARG}" ;;
    p) GITHUB_PASSWORD="${OPTARG}" ;;
#    t) TAG="${OPTARG}" ;;
    h) usage ;;
    ?) usage ;;
  esac
done


# check all arguments are provided
#if [ -z "${GITHUB_USERNAME}" ] || [ -z "${GITHUB_PASSWORD}" ] ; then
#  echo "All arguments are required"
#  usage
#fi

echo "====== INFO ======"
echo "Make sure you have the latest version of the repository checked out."
echo "react-o11y-app/push-to-dockerhub.sh -u github_username -p github_password"
echo "service-foundry-builder/push-to-dockerhub.sh -u github_username -p github_password"
echo "==================="

#CHART_VERSION="${TAG}"
#REPOSITORY="credemol/service-foundry-builder"

for chart in "${all_charts[@]}"; do
  REPOSITORY="credemol/${chart}"
  echo "Updating chart version for ${chart}"
#  echo "Updating chart version for ${chart} to ${TAG}"
  # update the chart version and repository in Chart.yaml and values.yaml manually
  # if OS is MacOS
#  if [[ "$OSTYPE" == "darwin"* ]]; then
#    sed -i '' "s/version:.*/version: ${TAG}/" "${chart}/Chart.yaml"
#    set -i '' "s/repository:.*/repository: ${REPOSITORY}/" "${chart}/values.yaml"
#    sed -i '' "s/tag:.*/tag: ${TAG}/" "${chart}/values.yaml"
#  else
#    sed -i "s/version:.*/version: ${TAG}/" "${chart}/Chart.yaml"
#    sed -i "s/repository:.*/repository: ${REPOSITORY}/" "${chart}/values.yaml"
#    sed -i "s/tag:.*/tag: ${TAG}/" "${chart}/values.yaml"
#  fi

  helm package ${chart}
done

helm repo index . --url https://nsalexamy.github.io/helm-charts

git add .
git commit -m "Update ${chart} chart at $(date)"

git push origin main

# If needed, create a new tag for the release manually
#git tag -a v${CHART_VERSION} -m "Release version $CHART_VERSION"
#git push origin v${CHART_VERSION}

echo "Merge the changes of main branch to the ph-pages branch on Github "

#!/bin/bash
set -e

all_charts=(
    "service-foundry-builder"
    "react-o11y-app"
)

usage() {
  echo ''
  echo ''
  echo "Usage: ${0} [-u github-username] [-p github-password] [-t tag]"
  echo ''
  echo 'options'
#  echo '  -a : AWS ACCOUNT ID'
  echo '  -r : AWS region'
  echo '  -c : ECR_NAME'
  echo '  -t : Tag for the docker image'
  echo '  -h : Display this help message'

  exit 1
}

#AWS_ACCOUNT_ID="${AWS_ACCOUNT_ID:-}"
AWS_REGION="${AWS_REGION:-}"
ECR_NAME="${ECR_NAME:-}"

while getopts "ha:r:c:t:" OPTION
do
  case ${OPTION} in
#    a) AWS_ACCOUNT_ID="${OPTARG}" ;;
    r) AWS_REGION="${OPTARG}" ;;
    c) ECR_NAME="${OPTARG}" ;;
    t) TAG="${OPTARG}" ;;
    h) usage ;;
    ?) usage ;;
  esac
done



# check all arguments are provided
if [ -z "${AWS_REGION}" ] || [ -z "${ECR_NAME}" ] || [ -z "${TAG}" ]; then
  echo "All arguments are required"
  usage
fi


CHART_VERSION="${TAG}"
REPOSITORY="${ECR_NAME}/service-foundry-builder"

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
  aws ecr get-login-password --region $AWS_REGION \
    | helm registry login --username AWS --password-stdin $ECR_NAME

  #aws ecr create-repository --repository-name helm-charts/${chart} \
  #  --region $AWS_REGION

  helm push ${chart}-${CHART_VERSION}.tgz oci://${ECR_NAME}/helm-charts
done



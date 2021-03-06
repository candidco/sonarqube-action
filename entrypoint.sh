#!/bin/bash

set -e

if [[ "${GITHUB_EVENT_NAME}" == "pull_request" ]]; then
	EVENT_ACTION=$(jq -r ".action" "${GITHUB_EVENT_PATH}")
	if [[ "${EVENT_ACTION}" != "opened" ]]; then
		echo "No need to run analysis. It is already triggered by the push event."
		exit 78
	fi
fi

[[ ! -z ${INPUT_EXCLUDE} ]] && EXCLUDE="${INPUT_EXCLUDE}" || EXCLUDE=""
[[ ! -z ${INPUT_PASSWORD} ]] && SONAR_PASSWORD="${INPUT_PASSWORD}" || SONAR_PASSWORD=""
[[ -z ${INPUT_PROJECTKEY} ]] && SONAR_PROJECTKEY="${PWD##*/}" || SONAR_PROJECTKEY="${INPUT_PROJECTKEY}"
[[ ! -z ${INPUT_PROJECTNAME} ]] && SONAR_PROJECTNAME="${INPUT_PROJECTNAME}" || SONAR_PROJECTNAME="${SONAR_PROJECTKEY}"

sonar-scanner \
	-Dsonar.host.url=${INPUT_HOST} \
	-Dsonar.projectName=${SONAR_PROJECTNAME} \
	-Dsonar.projectKey=${SONAR_PROJECTKEY} \
	-Dsonar.projectBaseDir=${INPUT_PROJECTBASEDIR} \
	-Dsonar.login=${INPUT_LOGIN} \
	-Dsonar.password=${INPUT_PASSWORD} \
	-Dsonar.sources=. \
	-Dsonar.sourceEncoding=UTF-8 \
	-Dsonar.exclusions=${INPUT_EXCLUDE} \
	${SONAR_PASSWORD}


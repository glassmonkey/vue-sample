#!/bin/bash
# referer to https://github.com/jessfraz/shaking-finger-action/blob/master/add-comment.sh
#!/bin/bash
set -e
set -o pipefail

if [[ -z "$GITHUB_TOKEN" ]]; then
	echo "Set the GITHUB_TOKEN env variable."
	exit 1
fi


if [[ -z "$GITHUB_REPOSITORY" ]]; then
	echo "Set the GITHUB_REPOSITORY env variable."
	exit 1
fi

URI=https://api.github.com
API_VERSION=v3
API_HEADER="Accept: application/vnd.github.${API_VERSION}+json; application/vnd.github.antiope-preview+json"
AUTH_HEADER="Authorization: token ${GITHUB_TOKEN}"
NUMBER=$(jq --raw-output .number "$GITHUB_EVENT_PATH")
PAYLOAD="# 変更前![変更前](${S3_PATH}/base.png)\n *** \n  # 変更後![変更後](${S3_PATH}/diff.png)\n *** \n # 差分![差分](${S3_PATH}/sub.png)"
curl -sSL -H "${AUTH_HEADER}" -H "${API_HEADER}" -d '{"body":"'"${PAYLOAD}"'"}' -H "Content-Type: application/json" -X POST "${URI}/repos/${GITHUB_REPOSITORY}/issues/${NUMBER}/comments"
#!/usr/bin/env bash

set -euo pipefail

install_tf()
{
    echo "\n Installing terraform"
    export TERRAFORM_VERSION=1.2.3
    if [[ ! -d .tfenv ]] ; then
        git clone --quiet --depth=1 \
            https://github.com/tfutils/tfenv.git $PWD/.tfenv
    fi
    export PATH="$PWD/.tfenv/bin:$PATH"
    tfenv use ${TERRAFORM_VERSION} | grep Default
}

log_msg()
{
  printf '=%.0s' {1..75}
  echo -e $1
  printf '=%.0s' {1..75}
  echo ""
}

impersonate_sa() 
{
    log_msg "\nINFO: ENV=$ENV APP=$APP impersonating GCP service account"
    export CONFIG_JSON="gcp_config_cicd.json"
    aws secretsmanager get-secret-value \
    --secret-id #SECRETNAME \
    --query SecretString \
    --output text > $PWD/$CONFIG_JSON

    ROLE_ARN="YOURROLEARN"
    SESSION_NAME=${ENV}_${APP}
    TEMP_ROLE=$(aws sts assume-role \
    --role-arn ${ROLE_ARN} \
    --role-session-name ${SESSION_NAME})
    export AWS_ACCESS_KEY_ID=$(jq -r '.Credentials.AccessKeyId' <<< ${TEMP_ROLE})
    export AWS_SECRET_ACCESS_KEY=$(jq -r '.Credentials.SecretAccessKey'  <<< ${TEMP_ROLE})
    export AWS_SESSION_TOKEN=$(jq -r '.Credentials.SessionToken'  <<< ${TEMP_ROLE})
    IDENTITY=$(aws sts get-caller-identity | jq .Arn)
    if [[ ! ${IDENTITY} =~ "gps-code-deploy-role/$SESSION_NAME" ]]; then
            log_msg "\nERROR: Unable to assume role $ROLE_ARN"
            exit 1
    fi

        export GOOGLE_APPLICATION_CREDENTIALS=$PWD/$CONFIG_JSON
        gcloud auth activate-service-account --key-file=$CONFIG_JSON
        log_msg "INFO: Activated GCP service account."
        gcloud config set project #GCPPROJECTID
        gcloud config list
    
}
#Getting variables value
GIT_TAG=$(tr -d ' ' <<< ${GIT_TAG} )
PATCH_FILE=$(tr -d ' ' <<< ${PATCH_FILE} )
ENV="#YOURENV"
APP="#YOURDEV"
GCP_PROJECT_ID="#YOURGCPPROJECTID"


#Main_steps
impersonate_sa
echo -e "\nCurrent GCP configurations:"
gcloud config configurations list
echo

# Trigger Cloud Build with the provided Git tag
echo -e "\nTriggering Cloud Build for Git tag: $GIT_TAG"
gcloud builds triggers run #triggername \
    --region= #trigger region \
    --substitutions=_GIT_TAG="$GIT_TAG"

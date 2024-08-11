#! /bin/bash

aws configure sso-session

aws sso login --sso-session quanianitis

# assignment/technology/account/region/service/environment/*
tf_state_dirs=(
  "./infra/terraform/aws/base/networking/production"
  "./infra/terraform/aws/base/eks/production"
  "./infra/terraform/aws/ap-southeast-3/antarticite/production"
)

for dir in "${tf_state_dirs[@]}"; do
    (cd "$dir" && terraform show)
done


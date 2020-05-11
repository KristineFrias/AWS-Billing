#!/bin/sh

bill=$(aws ce get-cost-and-usage \
    --time-period Start=2020-05-09,End=2020-05-10 \
    --granularity DAILY \
    --metrics "BlendedCost" "UnblendedCost" "UsageQuantity" \
    --group-by Type=DIMENSION,Key=SERVICE Type=TAG,Key=Environment \
    --filter file://filters.json \
    --output text \
    --profile edge \
    --region "us-east-1")

aws ses send-email \
 --from "no-reply+email-verify@viyahe.com" \
 --destination "ToAddresses=<mkfrias@viyahe.com>" \
 --message "Subject={Data=Billing alert,Charset=utf8},Body={Text={Data=$bill,Charset=utf8}}" \
 --profile edge \
 --region "us-west-2"

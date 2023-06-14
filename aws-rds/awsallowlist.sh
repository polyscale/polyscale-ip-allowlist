#!/bin/sh -e


#
# This script requires following environment variables to be properly set:
# AWS_PROFILE
# AWS_REGION
# AWS_ACCESS_KEY_ID
# AWS_SECRET_ACCESS_KEY
# AWS_SESSION_TOKEN (optional)
#
# this appends to the existing allow listed records for the specified SECGROUP
# make executable with: chmod +x awsallowlist.sh 
# execute with: ./awsallowlist.sh SECGROUP
# 

SECGROUP=$1

if [ -z "$SECGROUP" ]; then
    echo "Security group ID is required"
    exit 1
fi

ipranges=$(dig -t txt allowlist.psedge.global +short \
    | sed -e  's/"\([0-9.\/]*\)"/{CidrIp=\1, Description="PolyScale"}/g' \
    | paste -s -d, -)

aws ec2 authorize-security-group-ingress \
    --group-id $SECGROUP \
    --ip-permissions IpProtocol=tcp,FromPort=0,ToPort=65535,IpRanges="[$ipranges]"
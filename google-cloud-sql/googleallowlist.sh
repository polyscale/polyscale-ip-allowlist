#!/bin/bash

#
# this replaces all existing allow listed records for the specified INSTANCE_ID
# make executable with: chmod +x googleallowlist.sh 
# execute with: ./googleallowlist.sh INSTANCE_ID
#

INSTANCE_ID=$1

if [ -z "$INSTANCE_ID" ]; then
    echo "INSTANCE_ID is required"
    exit 1
fi

# Query the dig command and store the result in a variable
result=$(dig -t txt allowlist.psedge.global +short)

# Remove leading/trailing whitespace and quotation marks from the result
result=$(echo "$result" | tr -d ',' | tr -d '"')

# Remove leading/trailing whitespace and quotes from the original variable
result=$(echo "$result" | sed -e 's/^"//' -e 's/"$//' -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')

# Replace new lines with commas in the modified variable
result=$(echo "$result" | tr '\n' ',')

# Append the result as a comma-delimited list to the gcloud command
gcloud sql instances patch $INSTANCE_ID --authorized-networks="$result"
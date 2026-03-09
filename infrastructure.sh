#!/usr/bin/env bash

# infrastructure.sh
# creates a Resource Group, App Service Plan, and Web App in Azure using the Azure CLI
# Usage:
#   ./infrastructure.sh <rg-name> <location> <plan-name> <sku> <webapp-name> <runtime>
# Example:
#   ./infrastructure.sh myRG eastus myPlan P1V2 myWebApp "DOTNET|7.0"

set -euo pipefail

function usage() {
    cat <<EOF
Usage: $0 <rg-name> <location> <plan-name> <sku> <webapp-name> <runtime>

rg-name       - name of the resource group to create
location      - Azure region (e.g. eastus)
plan-name     - name of the App Service plan
sku           - SKU for the plan (e.g. F1, B1, P1V2)
webapp-name   - name of the Web App (must be globally unique)
runtime       - runtime stack for the Web App (e.g. "DOTNET|7.0", "NODE|16-lts")

Example:
  $0 myRG eastus myPlan P1V2 myWebApp "DOTNET|7.0"
EOF
}

if [[ $# -ne 6 ]]; then
    usage
    exit 1
fi

RG_NAME=$1
LOCATION=$2
PLAN_NAME=$3
SKU=$4
WEBAPP_NAME=$5
RUNTIME=$6

# create resource group
echo "Creating resource group '$RG_NAME' in '$LOCATION'..."
az group create --name "$RG_NAME" --location "$LOCATION"

# create app service plan
echo "Creating App Service plan '$PLAN_NAME' (SKU=$SKU)..."
az appservice plan create \
    --name "$PLAN_NAME" \
    --resource-group "$RG_NAME" \
    --sku "$SKU" \
    --is-linux false

# create web app
echo "Creating Web App '$WEBAPP_NAME' with runtime '$RUNTIME'..."
az webapp create \
    --name "$WEBAPP_NAME" \
    --resource-group "$RG_NAME" \
    --plan "$PLAN_NAME" \
    --runtime "$RUNTIME"

echo "Deployment complete."

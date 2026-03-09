# Course answer
#!/bin/bash
RESOURCE_GROUP="CopilotDevOpsRG"
LOCATION="eastus"
APP_SERVICE_PLAN="CopilotPlan"
WEBAPP_NAME="copilot-webapp-demo"
az group create --name $RESOURCE_GROUP --location $LOCATION
az appservice plan create --name $APP_SERVICE_PLAN --resource-group $RESOURCE_GROUP --sku B1 --is-linux
az webapp create --resource-group $RESOURCE_GROUP --plan $APP_SERVICE_PLAN --name $WEBAPP_NAME --runtime "NODE|14-lts"
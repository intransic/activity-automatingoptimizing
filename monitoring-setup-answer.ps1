$resourceGroup = "CopilotDevOpsRG"
$webAppName   = "copilot-webapp-demo"

# create an alert rule using Azure CLI wrapped in PowerShell style
az monitor metrics alert create \
    --name "HighCPUAlert" \
    --resource-group $resourceGroup \
    --scopes $(az webapp show --name $webAppName --resource-group $resourceGroup --query id -o tsv) \
    --condition "avg Percentage CPU > 80" \
    --description "CPU usage is high." \
    --window-size 5m \
    --evaluation-frequency 1m

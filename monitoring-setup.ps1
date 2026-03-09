# monitoring-setup.ps1
# configure Azure Monitor CPU alert for a Web App or VM

param (
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$true)]
    [string]$ResourceName,

    [Parameter(Mandatory=$true)]
    [string]$ResourceType, # e.g. "Microsoft.Web/sites" or "Microsoft.Compute/virtualMachines"

    [Parameter(Mandatory=$false)]
    [int]$CpuThreshold = 80,

    [Parameter(Mandatory=$false)]
    [int]$CpuWindowMinutes = 5,

    [Parameter(Mandatory=$false)]
    [string]$ActionGroupName = "HighCpuActionGroup"
)

# login should have been done already (Connect-AzAccount)

# ensure resource exists
$resource = Get-AzResource -ResourceGroupName $ResourceGroupName -Name $ResourceName -ResourceType $ResourceType -ErrorAction Stop

# create action group if not exists
$actionGroup = Get-AzActionGroup -Name $ActionGroupName -ResourceGroupName $ResourceGroupName -ErrorAction SilentlyContinue
if (-not $actionGroup) {
    Write-Host "Creating action group '$ActionGroupName'..."
    $actionGroup = New-AzActionGroup -Name $ActionGroupName -ResourceGroupName $ResourceGroupName -ShortName AG -Receiver @{Name="admin";EmailAddress="admin@example.com"}
}

$ruleName = "CpuAlert-$ResourceName"
Write-Host "Creating metric alert rule '$ruleName' on $ResourceType/$ResourceName"

# define condition
$condition = New-AzMetricAlertRuleV2Criteria -MetricName "Percentage CPU" -TimeAggregation Average -Operator GreaterThan -Threshold $CpuThreshold

# create or update the alert rule
New-AzMetricAlertRuleV2 -Name $ruleName \
    -ResourceGroupName $ResourceGroupName \
    -TargetResourceId $resource.ResourceId \
    -Condition $condition \
    -WindowSize (New-TimeSpan -Minutes $CpuWindowMinutes) \
    -Frequency (New-TimeSpan -Minutes 1) \
    -ActionGroup $actionGroup.Id

Write-Host "Alert rule created."

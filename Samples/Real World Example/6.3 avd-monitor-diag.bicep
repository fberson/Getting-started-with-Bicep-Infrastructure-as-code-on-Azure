targetScope = 'subscription'

//Define diagnostic setting  parameters
param resourceGroupProdPrefix string 
param resourceGroupAccPrefix string 
param resourceGroupPostfix string = '-001'
param logAnalyticsWorkspaceID string 
param logAnalyticslocation string = 'westeurope'
param AVDBackplaneProdResourceGroup string = '${resourceGroupProdPrefix}BACKPLANE${resourceGroupPostfix}'
param AVDBackplaneAccResourceGroup string = '${resourceGroupAccPrefix}BACKPLANE${resourceGroupPostfix}'
param hostpoolName1 string 
param workspaceName1 string
param hostpoolName2 string 
param workspaceName2 string

module AVDhostpooldiag1 './6.3.1 AVD-monitor-diag-hostpool.bicep' = {
  name: 'AVDhostpooldiag1'
  scope: resourceGroup(AVDBackplaneProdResourceGroup)
  params: {
    hostpoolName : hostpoolName1
    logAnalyticsWorkspaceID : logAnalyticsWorkspaceID
  }
}

module AVDWorkspacediag1 './6.3.2 AVD-monitor-diag-workspace.bicep' = {
  name: 'AVDWorkspacediag1'
  scope: resourceGroup(AVDBackplaneProdResourceGroup)
  params: {
    workspaceName : workspaceName1
    logAnalyticslocation : logAnalyticslocation
    logAnalyticsWorkspaceID : logAnalyticsWorkspaceID
  }
}

module AVDhostpooldiag2 './6.3.1 AVD-monitor-diag-hostpool.bicep' = {
  name: 'AVDhostpooldiag2'
  scope: resourceGroup(AVDBackplaneAccResourceGroup)
  params: {
    hostpoolName : hostpoolName2
    logAnalyticsWorkspaceID : logAnalyticsWorkspaceID
  }
}

module AVDWorkspacediag2 './6.3.2 AVD-monitor-diag-workspace.bicep' = {
  name: 'AVDWorkspacediag2'
  scope: resourceGroup(AVDBackplaneAccResourceGroup)
  params: {
    workspaceName : workspaceName2
    logAnalyticslocation : logAnalyticslocation
    logAnalyticsWorkspaceID : logAnalyticsWorkspaceID
  }
}

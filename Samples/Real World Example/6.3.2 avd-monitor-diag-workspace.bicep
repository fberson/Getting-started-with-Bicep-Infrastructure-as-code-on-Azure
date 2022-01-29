//Define diagnostic setting  parameters
param workspaceName string
param logAnalyticslocation string = 'westeurope'
param logAnalyticsWorkspaceID string

//Concat diagnostic setting names
var workspaceDiagName = '${workspaceName}/Microsoft.Insights/hostpool-diag'

//Create diagnostic settings for AVD Objects
resource AVDwsds 'Microsoft.DesktopVirtualization/workspaces/providers/diagnosticSettings@2017-05-01-preview' = {
  name: workspaceDiagName
  location: logAnalyticslocation
  properties: {
    workspaceId: logAnalyticsWorkspaceID
    logs: [
      {
        category: 'Checkpoint'
        enabled: true
      }
      {
        category: 'Error'
        enabled:  true
      }
      {
        category: 'Management'
        enabled: true
      }
      {
        category: 'Feed'
        enabled: true
      }
    ]
  }
}

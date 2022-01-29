//Define diagnostic setting  parameters
param hostpoolName string
param logAnalyticsWorkspaceID string

resource hostPool 'Microsoft.DesktopVirtualization/hostPools@2020-11-02-preview' existing = {
  name: hostpoolName
}

//Create diagnostic settings for AVD Objects
resource AVDwsds 'Microsoft.Insights/diagnosticSettings@2017-05-01-preview' = {
  name: '${hostPool}-diag'
  scope: hostPool
  properties: {
    workspaceId: logAnalyticsWorkspaceID
    logs: [
      {
        category: 'Checkpoint'
        enabled: true
      }
      {
        category: 'Error'
        enabled: true
      }
      {
        category: 'Management'
        enabled: true
      }
      {
        category: 'Connection'
        enabled: true
      }
      {
        category: 'HostRegistration'
        enabled: true
      }
    ]
  }
}

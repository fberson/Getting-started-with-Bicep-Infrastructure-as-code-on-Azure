//Define AVD deployment parameters
param hostpoolName string
param hostpoolFriendlyName string
param appgroupName string
param appgroupDesktopFriendlyName string
param appgroupRemoteAppFriendlyName string
param workspaceName string
param workspaceNameFriendlyName string
param preferredAppGroupType string = 'Desktop'
param AVDbackplanelocation string = 'eastus'
param hostPoolType string = 'pooled'
param loadBalancerType string = 'BreadthFirst'
param enableValiatioMode bool
param createRemoteAppHostpool bool

//Create AVD Hostpool
resource hp 'Microsoft.DesktopVirtualization/hostpools@2019-12-10-preview' = {
  name: hostpoolName
  location: AVDbackplanelocation
  properties: {
    friendlyName: hostpoolFriendlyName
    hostPoolType: hostPoolType
    loadBalancerType: loadBalancerType
    preferredAppGroupType: preferredAppGroupType
    validationEnvironment: enableValiatioMode
  }
}

//Create AVD Desktop AppGroup
resource agd 'Microsoft.DesktopVirtualization/applicationgroups@2019-12-10-preview' = {
  name: appgroupName
  location: AVDbackplanelocation
  properties: {
    friendlyName: appgroupDesktopFriendlyName
    applicationGroupType:  'Desktop'
    hostPoolArmPath: hp.id
  }
}

//Create AVD RemoteApp Hostpool
resource hpra 'Microsoft.DesktopVirtualization/hostpools@2019-12-10-preview' = if (createRemoteAppHostpool){
  name: '${hostpoolName}-REMOTEAPP'
  location: AVDbackplanelocation
  properties: {
    friendlyName: hostpoolFriendlyName
    hostPoolType: hostPoolType
    loadBalancerType: loadBalancerType
    preferredAppGroupType: 'RailApplications'
    validationEnvironment: enableValiatioMode
  }
}


//Create AVD RemoteApp AppGroup
resource agra 'Microsoft.DesktopVirtualization/applicationgroups@2019-12-10-preview' = if (createRemoteAppHostpool){
  name: '${appgroupName}-REMOTEAPP'
  location: AVDbackplanelocation
  properties: {
    friendlyName: appgroupRemoteAppFriendlyName
    applicationGroupType:  'RemoteApp'
    hostPoolArmPath: hpra.id
  }
}

//Create AVD Workspace in case createRemoteAppHostpool = false
resource ws 'Microsoft.DesktopVirtualization/workspaces@2019-12-10-preview' = {
  name: workspaceName
  location: AVDbackplanelocation
  properties: {
    friendlyName: workspaceNameFriendlyName
    applicationGroupReferences: [
      agd.id
      createRemoteAppHostpool ? agra.id : ''
    ]
  }
}




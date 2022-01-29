targetScope = 'subscription'

@secure()
param azureSubscriptionID string

@secure()
param azureADTenantID string

@secure()
param adminObjectID string

@secure()
param principalID string

//Define AVD deployment parameters
param resourceGroupProdPrefix string = 'BICEP-AVD-DEMO-P-'
param resourceGroupAccPrefix string = 'BICEP-AVD-DEMO-A-'
param resourceGroupPostfix string = '-RG'
param AVDbackplanelocation string = 'westeurope'
param hostPoolType string = 'pooled'
param loadBalancerType string = 'BreadthFirst'
param logAnalyticsWorkspaceName string = 'BICEP-AVD-DEMO-3'
param logAnalyticsWorkspaceSku string = 'pergb2018'
param hostpoolFriendlyName string = 'Hostpool with AVD Ninja Applications'
param appgroupDesktopFriendlyName string = 'AppGroup with AVD Ninja Desktop'
param appgroupRemoteAppFriendlyName string = 'AppGroup with AVD Ninja Applications'
param workspaceProdFriendlyName string = 'AVD Ninja Production'
param workspaceAccFriendlyName string = 'AVD Ninja Acceptance'

//Define Production parameters 
param hostpoolNameProd string = 'BICEP-P-AVD-HP'
param appgroupNameProd string = 'BICEP-P-AVD-HP-AG'
param workspaceNameProd string = 'BICEP-P-AVD-HP-WS'
param preferredAppGroupTypeProd string = 'Desktop'

//Define Acceptance parameters 
param hostpoolNameAcc string = 'BICEP-A-AVD-HP'
param appgroupNameAcc string = 'BICEP-A-AVD-HP-AG'
param workspaceNameAcc string = 'BICEP-A-AVD-HP-WS'
param preferredAppGroupTypeAcc string = 'Desktop'

//Define Networking deployment parameters
param vnetName string = 'BICEP-AVD-VNET'
param vnetaddressPrefix string = '10.80.0.0/16'
param subnet1Prefix string = '10.80.10.0/24'
param subnet1Name string = 'BICEP-AVD-SUBNET-PROD'
param subnet2Prefix string = '10.80.20.0/24'
param subnet2Name string = 'BICEP-AVD-SUBNET-ACC'
param dnsServer string = '10.50.1.4'

//define optional peering parameters
param createPeering bool = true
param remoteVnetName string = 'NINJA-WE-P-VNET-10-50-0-0-16'
param remoteVnetRg string = 'NINJA-WE-P-RG-NETWORK'

//Define Template VM & Packaging deployment parameters
param vmProdPrefix string = 'BICEP-AVD-VM-TEMPLATE-'
param adminUserName string = 'localadmin'

@secure()
param adminPassword string

param vmHostname1 string
var vnName1 = '${vmProdPrefix}${vmHostname1}'
param vmSize1 string = 'Standard_D4s_v3'

//Define SIG parameters
param sigName string = 'BICEP_AVD_AIB'

//Define Image Definition Parameteres
param imagePublisher string = 'AVDNinja'
param imageDefinitionName string = 'BICEP-AVD-ID'
param imageOffer string = 'Windows10-AVD'
param imageSKU string = '20h2-evd'

//Define Template Image parameters
param vmOffer string = 'windows-10'
param vmOSDiskSize int = 127
param vmSku string = '20h2-evd'
param vmVersion string = 'latest'
param vmPublisher string = 'MicrosoftWindowsDesktop'
param userAssignedIdentity string = 'BICEP-WVD-DEMO-IDENTITY'
var userAssignedIdentityID = '/subscriptions/${azureSubscriptionID}/resourcegroups/${rgti.name}/providers/Microsoft.ManagedIdentity/userAssignedIdentities/${userAssignedIdentity}'
param roleNameNetwork string = 'VvetReader'
param roleNameGalleryImage string = 'GalleryReadWrite'
param vmSizeAIB string = 'Standard_D16s_v3'

//Define Storage Account parameters AIB
param storageaccountlocation1 string = 'westeurope'
param storageaccountName1 string = 'bicepavdsaaib'
param storageaccountkind1 string = 'StorageV2'
param storgeaccountglobalRedundancy1 string = 'Standard_LRS'
param storageaccountlocation2 string = 'westeurope'
param storageaccountName2 string = 'bicepavdsaprof'
param storageaccountkind2 string = 'FileStorage'
param storgeaccountglobalRedundancy2 string = 'Premium_LRS'
param fileshareFolderName1 string = 'aibsoftware'
param fileshareFolderName2 string = 'aibscripts'
param fileshareFolderName3 string = 'profilecontainers'
var subnetID = '/subscriptions/${azureSubscriptionID}/resourcegroups/${resourceGroupProdPrefix}NETWORK${resourceGroupPostfix}/providers/Microsoft.Network/virtualNetworks/${vnetName}/subnets/${subnet2Name}'

//Define Keyvault Parameters
param keyVaultName string = 'kv-${utcNow()}'
param keyVaultLocation string = 'westeurope'
param secretNameDomainJoin string = 'AVD-domain-join'

@secure()
param secretValueDomainJoin string
param secretNameLocalAdminPassword string

@secure()
param secretValueLocalAdminPassword string

//Define Template Spec Parameters
param templateSpecName string = 'add-AVD-hosts-to-hostpool'
param templateDescription string = 'ARM Template to add hosts to an exsisting AVD Hostpool'
param templateDisplayName string = 'Add AVD hosts to hostpool'

//Create Resource Groups
resource rgnw 'Microsoft.Resources/resourceGroups@2020-06-01' = {
  name: '${resourceGroupProdPrefix}NETWORK${resourceGroupPostfix}'
  location: 'westeurope'
}
resource rgti 'Microsoft.Resources/resourceGroups@2020-06-01' = {
  name: 'BICEP-WVD-DEMO-P-TEMPLATE-IMAGE${resourceGroupPostfix}'
  location: 'westeurope'
}
resource rgtvm 'Microsoft.Resources/resourceGroups@2020-06-01' = {
  name: '${resourceGroupProdPrefix}TEMPLATE-VM${resourceGroupPostfix}'
  location: 'westeurope'
}
resource rgAVDp 'Microsoft.Resources/resourceGroups@2020-06-01' = {
  name: '${resourceGroupProdPrefix}BACKPLANE${resourceGroupPostfix}'
  location: 'westeurope'
}
resource rgAVDa 'Microsoft.Resources/resourceGroups@2020-06-01' = {
  name: '${resourceGroupAccPrefix}BACKPLANE${resourceGroupPostfix}'
  location: 'westeurope'
}
resource rgAVDphost 'Microsoft.Resources/resourceGroups@2020-06-01' = {
  name: '${resourceGroupProdPrefix}AVD-HOSTS${resourceGroupPostfix}'
  location: 'westeurope'
}
resource rgAVDahost 'Microsoft.Resources/resourceGroups@2020-06-01' = {
  name: '${resourceGroupAccPrefix}AVD-HOSTS${resourceGroupPostfix}'
  location: 'westeurope'
}
resource rgmon 'Microsoft.Resources/resourceGroups@2020-06-01' = {
  name: '${resourceGroupProdPrefix}MONITORING${resourceGroupPostfix}'
  location: 'westeurope'
}
resource rgfs 'Microsoft.Resources/resourceGroups@2020-06-01' = {
  name: '${resourceGroupProdPrefix}FILESERVICES${resourceGroupPostfix}'
  location: 'westeurope'
}
resource rgkv 'Microsoft.Resources/resourceGroups@2020-06-01' = {
  name: '${resourceGroupProdPrefix}KEYVAULT${resourceGroupPostfix}'
  location: 'westeurope'
}
resource rgts 'Microsoft.Resources/resourceGroups@2020-06-01' = {
  name: '${resourceGroupProdPrefix}TEMPLATESPECS${resourceGroupPostfix}'
  location: 'westeurope'
}

//Create Role Definition for Network Resource Group access
resource vnetdef 'Microsoft.Authorization/roleDefinitions@2018-01-01-preview' = {
  name: guid(roleNameNetwork)
  properties: {
    roleName: roleNameNetwork
    description: 'Custom role for network read'
    permissions: [
      {
        actions: [
          'Microsoft.Network/virtualNetworks/read'
          'Microsoft.Network/virtualNetworks/subnets/join/action'
        ]
      }
    ]
    assignableScopes: [
      subscription().id
    ]
  }
}

resource vnetass 'Microsoft.Authorization/roleAssignments@2018-09-01-preview' = {
  name: guid(rgnw.id)
  properties: {
    roleDefinitionId: vnetdef.id
    principalId: principalID
  }
}

var AVDbackplanes = [
  {
    hostpoolName: hostpoolNameProd
    hostpoolFriendlyName: hostpoolFriendlyName
    appgroupName: appgroupNameProd
    appgroupDesktopFriendlyName: appgroupDesktopFriendlyName
    appgroupRemoteAppFriendlyName: appgroupRemoteAppFriendlyName
    workspaceName: workspaceNameProd
    workspaceNameFriendlyName: workspaceProdFriendlyName
    preferredAppGroupType: preferredAppGroupTypeProd
    AVDbackplanelocation: AVDbackplanelocation
    hostPoolType: hostPoolType
    enableValiatioMode: false
    loadBalancerType: loadBalancerType
    createRemoteAppHostpool: true
  }
  {
    hostpoolName: hostpoolNameAcc
    hostpoolFriendlyName: hostpoolFriendlyName
    appgroupName: appgroupNameAcc
    appgroupDesktopFriendlyName: appgroupDesktopFriendlyName
    appgroupRemoteAppFriendlyName: appgroupRemoteAppFriendlyName
    workspaceName: workspaceNameAcc
    workspaceNameFriendlyName: workspaceAccFriendlyName
    preferredAppGroupType: preferredAppGroupTypeAcc
    AVDbackplanelocation: AVDbackplanelocation
    hostPoolType: hostPoolType
    enableValiatioMode: true
    loadBalancerType: loadBalancerType
    createRemoteAppHostpool: true
  }
]

//Create AVD Prod backplane objects and configure Log Analytics Diagnostics Settings
module AVDbackplaneprod './6.1 AVD-backplane-module.bicep' = [for AVDbackplane in AVDbackplanes: {
  name: '${AVDbackplane.hostpoolName}-deploy'
  scope: rgAVDp
  params: {
    hostpoolName: AVDbackplane.hostpoolName
    hostpoolFriendlyName: AVDbackplane.hostpoolFriendlyName
    appgroupName: AVDbackplane.appgroupName
    appgroupDesktopFriendlyName: AVDbackplane.appgroupDesktopFriendlyName
    appgroupRemoteAppFriendlyName: AVDbackplane.appgroupRemoteAppFriendlyName
    workspaceName: AVDbackplane.workspaceName
    workspaceNameFriendlyName: AVDbackplane.workspaceNameFriendlyName
    preferredAppGroupType: AVDbackplane.preferredAppGroupType
    AVDbackplanelocation: AVDbackplane.AVDbackplanelocation
    hostPoolType: AVDbackplane.HostPoolType
    enableValiatioMode: AVDbackplane.enableValiatioMode
    loadBalancerType: AVDbackplane.loadBalancerType
    createRemoteAppHostpool: AVDbackplane.createRemoteAppHostpool
  }
}]

//Create AVD Netwerk, Subnet and template image VM
module AVDnetwork './6.2 AVD-network-module.bicep' = {
  name: 'AVDnetwork'
  scope: rgnw
  params: {
    templateVMResourceGroup: rgtvm.name
    vnetLocation: rgnw.location
    vnetName: vnetName
    vnetaddressPrefix: vnetaddressPrefix
    dnsServer: dnsServer
    subnet1Prefix: subnet1Prefix
    subnet1Name: subnet1Name
    subnet2Prefix: subnet2Prefix
    subnet2Name: subnet2Name
    vmname: vnName1
    vmHostname: vmHostname1
    vmSize: vmSize1
    adminUserName: adminUserName
    adminPassword: adminPassword
    vmLocation: rgtvm.location
    createPeering: createPeering
    remoteVnetName: remoteVnetName
    remoteVnetRg: remoteVnetRg
    vNetVMResourceGroup: rgnw.name
  }
}

//Create Azure Log Analytics Workspace
module AVDmonitor './6.3 AVD-LogAnalytics.bicep' = {
  name: 'LAWorkspace'
  scope: rgmon
  params: {
    logAnalyticsWorkspaceName: logAnalyticsWorkspaceName
    logAnalyticslocation: rgmon.location
    logAnalyticsWorkspaceSku: logAnalyticsWorkspaceSku
  }
}

//Create Shared Image Gallery & Image Offers
module AVDsig './6.4 AVD-shared-image-gallery.bicep' = {
  name: 'AVDsig'
  scope: rgti
  params: {
    sigLocation: rgti.location
    sigName: sigName
    sigReourceGroup: rgti.name
    imageDefinitionName: imageDefinitionName
    imageOffer: imageOffer
    imagePublisher: imagePublisher
    imageSKU: imageSKU
    userIdentity: userAssignedIdentityID
    vmOffer: vmOffer
    vmOSDiskSize: vmOSDiskSize
    vmPublisher: vmPublisher
    vmSizeAIB: vmSizeAIB
    vmSku: vmSku
    vmVersion: vmVersion
    azureSubscriptionID: azureSubscriptionID
    subnetID: subnetID
    principalID: principalID
    roleNameGalleryImage: roleNameGalleryImage
    templateImageResourceGroup: rgti.name
  }
}

module AVDsa '6.5 AVD-fileservices-module.bicep' = {
  name: 'AVDsa'
  scope: rgfs
  params: {
    storageaccountlocation1: storageaccountlocation1
    storageaccountName1: storageaccountName1
    storageaccountkind1: storageaccountkind1
    storgeaccountglobalRedundancy1: storgeaccountglobalRedundancy1
    storageaccountlocation2: storageaccountlocation2
    storageaccountName2: storageaccountName2
    storageaccountkind2: storageaccountkind2
    storgeaccountglobalRedundancy2: storgeaccountglobalRedundancy2
    fileshareFolderName1: fileshareFolderName1
    fileshareFolderName2: fileshareFolderName2
    fileshareFolderName3: fileshareFolderName3
  }
}

//Create Azure KeyVault
module AVDkeyvault './6.6 AVD-KeyVault.bicep' = {
  name: 'AVDkeyvault'
  scope: rgkv
  params: {
    keyVaultName: keyVaultName
    keyVaultLocation: keyVaultLocation
    azureADTenantID: azureADTenantID
    adminObjectID: adminObjectID
    secretNameDomainJoin: secretNameDomainJoin
    secretValueDomainJoin: secretValueDomainJoin
    secretNameLocalAdminPassword: secretNameLocalAdminPassword
    secretValueLocalAdminPassword: secretValueLocalAdminPassword
  }
}

//Create template spec & template spec version
module AVDtemplatespec '7. AVD-template-spec.bicep' = {
  name: 'AVDtemplatespec'
  scope: rgts
  params: {
    templateSpecName: templateSpecName
    templateDescription: templateDescription
    templateDisplayName: templateDisplayName
  }
}

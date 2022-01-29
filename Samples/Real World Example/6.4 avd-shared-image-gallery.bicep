param azureSubscriptionID string

//Define SIG parameters
param sigName string
param sigLocation string
param sigReourceGroup string

//Define Image Definition parameters
param imagePublisher string
param imageDefinitionName string
param imageOffer string
param imageSKU string

//Define Template Image parameters
param userIdentity string
param vmOffer string
param vmOSDiskSize int
param vmSku string
param vmVersion string
param vmPublisher string
param vmSizeAIB string
param subnetID string

//define user identity
param roleNameGalleryImage string
param principalID string
param templateImageResourceGroup string

//Define Azure Subscriptin ID params
var assignableScopes = '/subscriptions/${azureSubscriptionID}/resourcegroups/${templateImageResourceGroup}'

//Create Image Gallery
resource AVDsig 'Microsoft.Compute/galleries@2020-09-30' = {
  name: sigName
  location: sigLocation
}

//create role definition
resource gallerydef 'Microsoft.Authorization/roleDefinitions@2018-01-01-preview' = {
  name: guid(roleNameGalleryImage)
  properties: {
    roleName: roleNameGalleryImage
    description: 'Custom role for network read'
    permissions: [
      {
        actions: [
          'Microsoft.Compute/galleries/read'
          'Microsoft.Compute/galleries/images/read'
          'Microsoft.Compute/galleries/images/versions/read'
          'Microsoft.Compute/galleries/images/versions/write'
          'Microsoft.Compute/images/write'
          'Microsoft.Compute/images/read'
          'Microsoft.Compute/images/delete'
        ]
      }
    ]
    assignableScopes: [
      assignableScopes
    ]
  }
  dependsOn:[
    AVDsig
  ]
}

//create role assignment
resource galleryass 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  name: guid(resourceGroup().id)
  properties: {
    roleDefinitionId: gallerydef.id
    principalId: principalID
  }
  dependsOn:[
    AVDsig
  ]
}

//Create Image Definition
module AVDid './6.4.1 AVD-Image-definitions.bicep' = {
  name: 'AVDid'
  scope: resourceGroup(sigReourceGroup)
  params: {
    imageGalleryName: sigName
    imageLocation: sigLocation
    imageDefinitionName: imageDefinitionName
    imageOffer: imageOffer
    imagePublisher: imagePublisher
    imageSKU: imageSKU
    templateImageResourceGroup: sigReourceGroup
    imageTemplateName: imageDefinitionName
    userIdentity: userIdentity
    vmOffer: vmOffer
    vmOSDiskSize: vmOSDiskSize
    vmPublisher: vmPublisher
    vmSize: vmSizeAIB
    vmSku: vmSku
    vmVersion: vmVersion
    azureSubscriptionID: azureSubscriptionID
    subnetID: subnetID
  }
  dependsOn:[
    AVDsig
  ]
}

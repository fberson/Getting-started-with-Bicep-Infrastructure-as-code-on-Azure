//Define Image Definition parameters
param azureSubscriptionID string
param imageGalleryName string
param imageDefinitionName string
param imageLocation string
param imagePublisher string
param imageOffer string
param imageSKU string
param templateImageResourceGroup string
param imageTemplateName string
param userIdentity string
param vmOffer string
param vmSize string
param vmOSDiskSize int
param vmPublisher string
param vmSku string
param vmVersion string
param subnetID string

var imageDefinitionFullName = '${imageGalleryName}/${imageDefinitionName}'

//Create Image definitation
resource AVDid 'Microsoft.Compute/galleries/images@2020-09-30' = {
  name: imageDefinitionFullName
  location: imageLocation
  properties: {
    osState: 'Generalized'
    osType: 'Windows'
    identifier: {
      publisher: imagePublisher
      offer: imageOffer
      sku: imageSKU
    }
  }
}

module AVDti './6.4.1.1 AVD-image-template.bicep' = {
  name: imageTemplateName
  scope: resourceGroup(templateImageResourceGroup)
  params: {
    azureSubscriptinID: azureSubscriptionID
    imageGalleryName: imageGalleryName
    imageGalleryRecourceGroupName: templateImageResourceGroup    
    imageTemplateLocation: imageLocation
    imageTemplateName: imageTemplateName
    userIdentity: userIdentity
    vmOffer: vmOffer
    vmOSDiskSize: vmOSDiskSize
    vmPublisher: vmPublisher
    vmSize: vmSize
    vmSku: vmSku
    vmVersion: vmVersion
    subnetID: subnetID
  }
}

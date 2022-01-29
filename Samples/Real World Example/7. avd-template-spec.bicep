param templateSpecName string = 'add-wvd-hosts-to-hostpool'
param templateDescription string = 'ARM Template to add hosts to an existing WVD Hostpool'
param templateDisplayName string = 'Add WVD hosts to hostpool'

resource ts 'Microsoft.Resources/templateSpecs@2019-06-01-preview' = {
  name: templateSpecName
  location: resourceGroup().location
  properties: {
    description: templateDescription
    displayName: templateDisplayName
  }
}

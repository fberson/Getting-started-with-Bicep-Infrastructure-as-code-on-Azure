param templateSpecName string = 'create-storageaccount'
param templateDescription string = 'Template spec to create new storage account'
param templateDisplayName string = 'Create a new storage account'

resource ts 'Microsoft.Resources/templateSpecs@2019-06-01-preview' = {
  name: templateSpecName
  location: resourceGroup().location
  properties: {
    description: templateDescription
    displayName: templateDisplayName
  }
}

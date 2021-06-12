@description('Enter the prefix you want to use for the storage account (default = stg).')
@maxLength(3)
param namePrefix string = 'stg'

@description('Provide the location where to depploy the storage account (default = westeurope).')
param location string = 'westeurope'

var storageAccountName = '${namePrefix}${uniqueString(resourceGroup().id)}'

resource stg 'Microsoft.Storage/storageAccounts@2021-02-01' = {
  name: storageAccountName
  location: location
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
    tier: 'Standard'
  }
  properties: {
    accessTier: 'Hot'
  }
}

resource blob 'Microsoft.Storage/storageAccounts/blobServices/containers@2019-06-01' = {
  name: '${stg.name}/default/myblob'
}

output stgout string = stg.properties.primaryEndpoints.blob

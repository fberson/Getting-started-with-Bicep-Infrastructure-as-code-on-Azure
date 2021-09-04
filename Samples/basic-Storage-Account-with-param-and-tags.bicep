param storageAccountName string = 'mysabicepdemo'
param location string = 'westeurope'

param resourceTags object = {
  Environment: 'Dev'
  Project: 'Mastering Bicep'
}

resource stg 'Microsoft.Storage/storageAccounts@2021-02-01' = {
  name: storageAccountName
  location: location
  tags: resourceTags
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
  properties: {
    accessTier: 'Hot'
  }
}

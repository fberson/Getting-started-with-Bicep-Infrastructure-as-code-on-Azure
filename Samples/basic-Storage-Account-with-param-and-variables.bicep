param storageAccountName string = 'mysabicepdemo'
param location string = 'westeurope'

var storageTier = 'Standard'

resource storageAccountName_resource 'Microsoft.Storage/storageAccounts@2021-02-01' = {
  name: storageAccountName
  location: location
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
    tier: storageTier
  }
  properties: {
    accessTier: 'Hot'
  }
}

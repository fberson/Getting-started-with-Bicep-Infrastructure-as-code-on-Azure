param storageAccountName string = 'mysabicepdemo'
param location string = 'westeurope'

resource stg 'Microsoft.Storage/storageAccounts@2021-02-01' = {
  name: storageAccountName
  location: location
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
  properties: {
    accessTier: 'Hot'
  }
}

output stg string = stg.properties.primaryEndpoints.blob

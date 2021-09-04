resource stg 'Microsoft.Storage/storageAccounts@2021-02-01' = {
  name: 'mysabicepdemo'
  location: 'westeurope'
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
  properties: {
    accessTier: 'Hot'
  }
}

param storageAccountName string = 'mysabicepdemo'
param location string
@description('The Access Tier only allows Hot or Cool')
@allowed([
  'Hot'
  'Cool'
])
param accessTier string

resource stg 'Microsoft.Storage/storageAccounts@2021-02-01' = {
  name: storageAccountName
  location: location
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
  properties: {
    accessTier: accessTier
    allowBlobPublicAccess: true
  }
}

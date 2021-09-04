param namePrefix string = 'stg'
param location string = 'westeurope'
param hotAccessTier bool = true
var storageAccountName = '${namePrefix}${uniqueString(resourceGroup().id)}'

resource stg 'Microsoft.Storage/storageAccounts@2021-02-01' = {
  name: storageAccountName
  location: location
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
  properties: {
    accessTier: hotAccessTier ? 'Hot' : 'Cool'     
  }
}

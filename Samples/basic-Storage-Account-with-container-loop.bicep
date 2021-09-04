param namePrefix string = 'stg'
param location string = 'westeurope'
param blobContainerNames array = [
  'bicep'
  'simply'
  'rules'
]
var storageAccountName = '${namePrefix}${uniqueString(resourceGroup().id)}'

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

resource blob 'Microsoft.Storage/storageAccounts/blobServices/containers@2019-06-01' = [for name in blobContainerNames: {
  name: '${stg.name}/default/${name}'
}]

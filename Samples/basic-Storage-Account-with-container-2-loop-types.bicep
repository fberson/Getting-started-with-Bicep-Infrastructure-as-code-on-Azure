param namePrefix string = 'stg'
param location string = 'westeurope'

param blobContainers array = [
  {
    Name: 'bicep'
    publicAccess: 'blob'
  }
  {
    Name: 'simply'
    publicAccess: 'container'
  }
  {
    Name: 'rules'
    publicAccess: 'none'
  }
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

resource blob 'Microsoft.Storage/storageAccounts/blobServices/containers@2019-06-01' = [for (container, i) in blobContainers: {
  name: '${stg.name}/default/${i}-${container.name}'
  properties: {
    publicAccess: container.publicAccess
  }
}]

output stg string = stg.name

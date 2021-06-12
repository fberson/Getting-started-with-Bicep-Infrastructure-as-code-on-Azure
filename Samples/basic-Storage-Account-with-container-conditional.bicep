param namePrefix string = 'stg'
param location string = 'westeurope'
param createContainer bool = true

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

resource blob 'Microsoft.Storage/storageAccounts/blobServices/containers@2019-06-01' = if (createContainer == true) {
  name: '${stg.name}/default/myblob'
}

output stg string = stg.name
Code Sample [19] basic-Storage-Account
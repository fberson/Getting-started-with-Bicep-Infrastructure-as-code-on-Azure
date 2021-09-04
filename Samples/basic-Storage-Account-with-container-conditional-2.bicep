param namePrefix string = 'stg'
param location string = 'westeurope'
param createContainer string = utcNow('MM')

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

resource blobMay 'Microsoft.Storage/storageAccounts/blobServices/containers@2019-06-01' = if (createContainer == '05') {
  name: '${stg.name}/default/may'
}

resource blobJune 'Microsoft.Storage/storageAccounts/blobServices/containers@2019-06-01' = if (createContainer == '06') {
  name: '${stg.name}/default/june'
}

output stg string = stg.name

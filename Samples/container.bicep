param storageAccountName string
param containerName string
param containerIndex int

resource blob 'Microsoft.Storage/storageAccounts/blobServices/containers@2019-06-01' = {
  name: '${storageAccountName}/default/${containerIndex}${containerName}'
}

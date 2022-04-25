param storageAccountName string
param containerName string
@secure()
param secretMetadata string

resource blob 'Microsoft.Storage/storageAccounts/blobServices/containers@2019-06-01' = {
  name: '${storageAccountName}/default/${containerName}'
  properties:{
    metadata: {
      secret: secretMetadata
    }
  }
}

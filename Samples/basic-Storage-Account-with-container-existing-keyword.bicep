param storageAccountName string = 'stgiywdzdqmmr2ke'

resource stg 'Microsoft.Storage/storageAccounts@2021-02-01' existing = {
  name: storageAccountName
}

resource blob 'Microsoft.Storage/storageAccounts/blobServices/containers@2019-06-01' = {
  name: '${stg.name}/default/myblob'
}

output stg string = stg.name

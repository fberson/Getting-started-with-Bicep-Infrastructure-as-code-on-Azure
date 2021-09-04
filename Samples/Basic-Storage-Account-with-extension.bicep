param storageAccountName string = 'mysabicepdemo'
param location string
@allowed([
  'Hot'
  'Cool'
])
param accessTier string
param roleNameGuid string = newGuid()
param principalId string

var role = '/subscriptions/${subscription().subscriptionId}/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c'

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

resource roleAssignStorage 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  name: roleNameGuid
  properties: {
    roleDefinitionId: role
    principalId: principalId
  }
  scope: stg
}

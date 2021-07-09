targetScope = 'subscription'

param resourceGroupName string = 'my-rg'
param storageAccountName string
param containerName string
param keyVaultName string
param keyVaultSubscription string
param keyVaultResourceGroup string
param secretName string
param secretVersion string

resource rg 'Microsoft.Resources/resourceGroups@2021-01-01' = {
  name: resourceGroupName
  location: 'westeurope'
}

resource sa 'Microsoft.Storage/storageAccounts@2021-02-01' existing = {
  name: storageAccountName
  scope: rg
}

resource kv 'Microsoft.KeyVault/vaults@2019-09-01' existing = {
  name: keyVaultName
  scope: resourceGroup(keyVaultSubscription, keyVaultResourceGroup)
}

module co 'container.bicep' = {
  scope: rg
  name: 'sa'
  params: {
    containerName: containerName
    storageAccountName: sa.name
    secretMetadata: kv.getSecret(secretName, secretVersion)
  }
}

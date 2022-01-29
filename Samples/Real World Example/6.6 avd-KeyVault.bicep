//Define Log Analytics parameters
param keyVaultName string
param keyVaultLocation string
param azureADTenantID string
param adminObjectID string
param sku string = 'Standard'
param enabledForDeployment bool = true
param enabledForTemplateDeployment bool = true
param enabledForDiskEncryption bool = true
param enableRbacAuthorization bool = false
param softDeleteRetentionInDays int = 90
param secretNameDomainJoin string
param secretValueDomainJoin string
param secretNameLocalAdminPassword string
param secretValueLocalAdminPassword string
param accessPolicies array = [
  {
    tenantId: azureADTenantID
    objectId: adminObjectID 
    permissions: {
      keys: [
        'Get'
        'List'
        'Update'
        'Create'
        'Import'
        'Delete'
        'Recover'
        'Backup'
        'Restore'
      ]
      secrets: [
        'Get'
        'List'
        'Set'
        'Delete'
        'Recover'
        'Backup'
        'Restore'
      ]
      certificates: [
        'Get'
        'List'
        'Update'
        'Create'
        'Import'
        'Delete'
        'Recover'
        'Backup'
        'Restore'
        'ManageContacts'
        'ManageIssuers'
        'GetIssuers'
        'ListIssuers'
        'SetIssuers'
        'DeleteIssuers'
      ]
    }
  }
]
param networkAcls object = {
  ipRules: []
  virtualNetworkRules: []
}

//Create Keyvault
resource keyvault 'Microsoft.KeyVault/vaults@2019-09-01' = {
  name: keyVaultName
  location: keyVaultLocation
  properties: {
    tenantId: azureADTenantID
    sku: {
      family: 'A'
      name: sku
    }
    accessPolicies: accessPolicies
    enabledForDeployment: enabledForDeployment
    enabledForDiskEncryption: enabledForDiskEncryption
    enabledForTemplateDeployment: enabledForTemplateDeployment
    softDeleteRetentionInDays: softDeleteRetentionInDays
    enableRbacAuthorization: enableRbacAuthorization
    networkAcls: networkAcls
  }
}

// create secrets
resource secretdj 'Microsoft.KeyVault/vaults/secrets@2018-02-14' = {
  name: '${keyvault.name}/${secretNameDomainJoin}'
  properties: {
    value: secretValueDomainJoin
  }
}
resource secretla 'Microsoft.KeyVault/vaults/secrets@2018-02-14' = {
  name: '${keyvault.name}/${secretNameLocalAdminPassword}'
  properties: {
    value: secretValueLocalAdminPassword
  }
}



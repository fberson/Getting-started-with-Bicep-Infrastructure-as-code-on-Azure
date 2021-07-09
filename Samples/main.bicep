targetScope = 'subscription'

param namePrefix string
param location string
param resourceGroupName string = 'my-rg'

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

resource rg 'Microsoft.Resources/resourceGroups@2021-01-01' = {
  name: resourceGroupName
  location: 'westeurope'
}

module sa 'storageAccount.bicep' ={
  name: 'sa-module'
  scope: rg
  params: {
    location: location
    namePrefix: namePrefix
  }
}

module co 'container.bicep' = [for (container, i) in blobContainers: {
  name: 'co-module-${i}'
  scope: rg
  params: {
    containerName: container.Name
    containerIndex: i
    storageAccountName: sa.outputs.stg
  }
}]

output saout string = sa.outputs.stg

targetScope = 'subscription'

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

module co_ts 'ts/CoreSpecs:create-storageaccount:v1' = [for (container, i) in blobContainers: {
  name: 'co-module-${i}'
  scope: rg
  params: {
    accessTier: 'Hot'
    location: 'west europe'
  }
}]

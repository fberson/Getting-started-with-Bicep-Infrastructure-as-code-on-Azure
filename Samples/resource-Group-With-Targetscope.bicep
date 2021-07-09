targetScope = 'subscription'

param resourceGroupName string = 'my-rg'

resource rg 'Microsoft.Resources/resourceGroups@2021-01-01' = {
  name: resourceGroupName
  location: 'westeurope'
}

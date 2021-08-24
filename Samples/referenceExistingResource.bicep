param vnetName string
param vnetResourceGroupName string
param subnetName string
param subscriptionID string

resource vnet 'Microsoft.Network/virtualNetworks@2020-05-01' existing = {
  name: vnetName
  scope: resourceGroup(subscriptionID,vnetResourceGroupName)
}

resource vmNic 'Microsoft.Network/networkInterfaces@2017-06-01' = {
  name: 'demo-nic'
  location: resourceGroup().location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          subnet: {
            id: '${vnet.id}/subnets/${subnetName}'
          }
          privateIPAllocationMethod: 'Dynamic'
        }
      }
    ]
  }
}

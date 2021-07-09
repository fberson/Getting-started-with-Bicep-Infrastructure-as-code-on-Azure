resource vnet1 'Microsoft.Network/virtualNetworks@2020-06-01' = {
  name: 'vnet-demo-1'
  location: resourceGroup().location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.10.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'subnet-demo-1'
        properties: {
          addressPrefix: '10.10.0.0/24'
        }
      }
    ]
  }
}

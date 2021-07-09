resource vnet1 'Microsoft.Network/virtualNetworks@2020-11-01' = {
  name: 'vnet-demo-3'
  location: resourceGroup().location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
  }

  resource subnet 'subnets' = {
    name: 'subnet-demo-3'
    properties: {
      addressPrefix: '10.0.0.0/24'
    }
  }
}

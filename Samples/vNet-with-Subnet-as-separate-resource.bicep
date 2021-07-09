resource vnet2 'Microsoft.Network/virtualNetworks@2020-11-01' = {
  name: 'vnet-demo-2'
  location: resourceGroup().location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
  }
}

resource subnet 'Microsoft.Network/virtualNetworks/subnets@2020-11-01' = {
  name: '${vnet2.name}/subnet-demo-2'
  properties: {
    addressPrefix: '10.0.0.0/24'
  }
}

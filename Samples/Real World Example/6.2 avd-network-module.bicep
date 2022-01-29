// Define Networking parameters
param vnetLocation string
param vnetName string
param vnetaddressPrefix string
param subnet1Prefix string
param subnet1Name string
param subnet2Prefix string
param subnet2Name string
param dnsServer string

//Define AVD Template Image deployment parameters
param vmname string
param vmHostname string
param vmSize string
param vmLocation string
param templateVMResourceGroup string
param adminUserName string
param adminPassword string

//define peering parameters
param createPeering bool
param remoteVnetRg string
param remoteVnetName string

//define user identity
param vNetVMResourceGroup string

//Create Vnet and Subnet
resource vnet 'Microsoft.Network/virtualnetworks@2020-06-01' = {
  name: vnetName
  location: vnetLocation
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetaddressPrefix
      ]
    }
    dhcpOptions: {
      dnsServers: [
        dnsServer
      ]
    }
    subnets: [
      {
        name: subnet1Name
        properties: {
          addressPrefix: subnet1Prefix
        }
      }
      {
        name: subnet2Name
        properties: {
          addressPrefix: subnet2Prefix
          privateLinkServiceNetworkPolicies: 'Disabled'
        }
      }
    ]
  }
}



//Optionally create vnet peering to an ADDS vnet
resource peertoadds 'microsoft.network/virtualNetworks/virtualNetworkPeerings@2020-05-01' = if (createPeering) {
  name: '${vnet.name}/peering-to-adds-vnet'
  properties: {
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: false
    allowGatewayTransit: false
    useRemoteGateways: false
    remoteVirtualNetwork: {
      id: resourceId(remoteVnetRg, 'Microsoft.Network/virtualNetworks', remoteVnetName)
    }
  }
}

//Optionally create vnet peering from an ADDS vnet
module peerfromadds './6.2.2 AVD-peering-from-adds.bicep' = if (createPeering){
  name: 'peering'
  scope: resourceGroup(remoteVnetRg)
  params: {
    remoteVnetName: remoteVnetName
    vnetName: vnet.name
    vnetNameResourceGroup: vNetVMResourceGroup
  }
}

//Create AVD Template VM
module tvm './6.2.1 AVD-template-vm.bicep' = {
  name: 'tvmbim'
  scope: resourceGroup(templateVMResourceGroup)
  params: {
    vmname: vmname
    vmHostname: vmHostname
    adminUserName: adminUserName
    adminPassword: adminPassword
    vmLocation: vmLocation
    vmSize: vmSize
    subnetName: subnet2Name
    vnetid: vnet.id
  }
}

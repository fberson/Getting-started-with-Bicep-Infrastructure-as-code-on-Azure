param localAdminName string
@secure()
param localAdminPassword string
param vmSku string = 'Standard_D4s_v4'
param vmOS string = '2019-Datacenter'
param vmName string = 'demo'
param vnetName string = 'vnet'
param nicName string = 'demo'

var vnetConfig = {
  vnetprefix: '10.0.0.0/16'
  subnet: {
    name: 'bicep-demo-subnet'
    subnetPrefix: '10.0.66.0/24'
  }
}
var defaultLocation = resourceGroup().location
var privateIPAllocationMethod = 'Dynamic'

var sharedNamePrefixes = json(loadTextContent('./shared-prefixes.json'))
var vmFullName = '${sharedNamePrefixes.companyResourcePrefix}-${sharedNamePrefixes.productionResourcePrefix}-${vmName}-${sharedNamePrefixes.globalPostFix}'
var nicFullName = '${sharedNamePrefixes.companyResourcePrefix}-${sharedNamePrefixes.productionResourcePrefix}-${nicName}-${sharedNamePrefixes.globalPostFix}'
var vnetFullName = '${sharedNamePrefixes.companyResourcePrefix}-${sharedNamePrefixes.productionResourcePrefix}-${vnetName}-${sharedNamePrefixes.globalPostFix}'

resource vnet 'Microsoft.Network/virtualNetworks@2020-05-01' = {
  name: vnetFullName
  location: defaultLocation
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetConfig.vnetprefix
      ]
    }
    subnets: [
      {
        name: vnetConfig.subnet.name
        properties: {
          addressPrefix: vnetConfig.subnet.subnetPrefix
        }
      }
    ]
  }
}

resource vmNic 'Microsoft.Network/networkInterfaces@2017-06-01' = {
  name: nicFullName
  location: defaultLocation
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          subnet: {
            id: '${vnet.id}/subnets/${vnetConfig.subnet.name}'
          }
          privateIPAllocationMethod: privateIPAllocationMethod
        }
      }
    ]
  }
}

resource vm 'Microsoft.Compute/virtualMachines@2019-07-01' = {
  name: vmFullName
  location: defaultLocation
  properties: {
    osProfile: {
      computerName: vmFullName
      adminUsername: localAdminName
      adminPassword: localAdminPassword
    }
    hardwareProfile: {
      vmSize: vmSku
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: vmOS
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          properties: {
            primary: true
          }
          id: vmNic.id
        }
      ]
    }
  }
}

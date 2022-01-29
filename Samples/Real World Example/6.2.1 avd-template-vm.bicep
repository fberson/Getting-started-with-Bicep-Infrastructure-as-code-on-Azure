//Define AVD Template Image deployment parameters
param vmname string
param vmHostname string
param vmLocation string = 'westeurope'
param vmSize string
param adminUserName string
param adminPassword string
param vnetid string
param subnetName string
var nicName = '${vmname}-nic'
var subnetRef = '${vnetid}/subnets/${subnetName}'

resource nic 'Microsoft.Network/networkInterfaces@2020-06-01' = {
  name: nicName
  location: vmLocation

  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: subnetRef
          }
        }
      }
    ]
  }
}

//Create AVD Template Image VM
resource vm 'Microsoft.Compute/virtualMachines@2020-06-01' = {
  name: vmname
  location: vmLocation
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }
    osProfile: {
      computerName: vmHostname
      adminUsername: adminUserName
      adminPassword: adminPassword
    }
    storageProfile: {
      imageReference: {
        publisher: 'microsoftwindowsdesktop'
        offer: 'Windows-10'
        sku: '20h1-evd'
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
        name: '${vmname}-osdisk'
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: nic.id
        }
      ]
    }
  }
}

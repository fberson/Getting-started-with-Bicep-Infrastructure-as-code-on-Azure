//Define Log Analytics parameters
param azureSubscriptinID string
param imageGalleryName string
param imageGalleryRecourceGroupName string
param imageTemplateName string
param imageTemplateLocation string
param vmSize string
param vmOSDiskSize int
param vmPublisher string
param vmOffer string
param vmSku string
param vmVersion string
param userIdentity string
param subnetID string

var galleryImageId = '/subscriptions/${azureSubscriptinID}/resourceGroups/${imageGalleryRecourceGroupName}/providers/Microsoft.Compute/galleries/${imageGalleryName}/images/${imageTemplateName}'

//Create template image
resource AVDit 'Microsoft.VirtualMachineImages/imageTemplates@2020-02-14' = {
  name: imageTemplateName
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities :{
      '${userIdentity}': {}
    }
  }
  location: imageTemplateLocation
  properties: {
    buildTimeoutInMinutes: 100
    vmProfile: {
      vmSize: vmSize
      osDiskSizeGB: vmOSDiskSize     
    }
    source : {
      type: 'PlatformImage'
      publisher: vmPublisher
      offer: vmOffer
      sku: vmSku
      version: vmVersion
    }
    customize: [
      {
        type: 'PowerShell'
        name: 'GetAzCopy'
        inline:[
          'New-Item -type Directory -Path C:\\ -Name temp'
          'Invoke-WebRequest -Uri https://aka.ms/downloadazcopy-v10-windows -OutFile c:\\temp\\azcopy.zip'
          'Expand-Archive C:\\temp\\azcopy.zip c:\\temp'
          'Copy-Item C:\\temp\\azcopy_windows_amd64_*\\azcopy.exe\\ -Destination C:\\temp'
        ]
      }
      {
        type: 'PowerShell'
        name: 'GetCustomizeScriptAndApps'
        inline:[
          'C:\\temp\\azcopy.exe copy "https://ninjawvdprofiles.blob.core.windows.net/liquit/avd-liquit-aib-demo.msi?sp=r&st=2021-09-13T12:15:54Z&se=2022-10-06T20:15:54Z&spr=https&sv=2020-08-04&sr=b&sig=1esX6FXbDM9reIHS8%2BEaywhVFLl342qMrhooi%2BKAOlY%3D"  C:\\temp\\avd-liquit-aib-demo.msi'
          'C:\\temp\\azcopy.exe copy "https://ninjawvdprofiles.blob.core.windows.net/liquit/avd-ninja-aib-deploy.ps1?sp=r&st=2021-09-13T12:16:13Z&se=2022-11-17T21:16:13Z&spr=https&sv=2020-08-04&sr=b&sig=DlNnL54AlrApHJvZxVaKLvbH3odr9S8oH8TfVd8wjEc%3D"  C:\\temp\\avd-ninja-aib-deploy.ps1'
          'C:\\temp\\azcopy.exe copy "https://ninjawvdprofiles.blob.core.windows.net/liquit/run-ShellAPI.ps1?sp=r&st=2021-09-19T08:24:10Z&se=2023-01-19T17:24:10Z&spr=https&sv=2020-08-04&sr=b&sig=d%2Fz1wjFHGKBEvZHCMg4NQssJ4wp8qsuwL2hvQwiX%2FyM%3D"  C:\\temp\\run-ShellAPI.ps1'

          

          'Set-ExecutionPolicy Bypass -Force'
          'C:\\temp\\avd-ninja-aib-deploy.ps1'
        ]
        runElevated : true
      }
    ]
    distribute: [
      {
        type: 'SharedImage'
        galleryImageId: galleryImageId
        runOutputName: imageTemplateName
        replicationRegions: [
          'North Europe'
        ]
      }
    ]
    }
}




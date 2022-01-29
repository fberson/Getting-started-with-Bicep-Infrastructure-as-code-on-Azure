//Define Azure Files parmeters
param storageaccountlocation1 string
param storageaccountName1 string
param storageaccountkind1 string
param storgeaccountglobalRedundancy1 string
param storageaccountlocation2 string
param storageaccountName2 string
param storageaccountkind2 string
param storgeaccountglobalRedundancy2 string
param fileshareFolderName1 string
param fileshareFolderName2 string
param fileshareFolderName3 string

//Concat FileShare
var filesharelocation1 = '${saaib.name}/default/${fileshareFolderName1}'
var filesharelocation2 = '${saaib.name}/default/${fileshareFolderName2}'
var filesharelocation3 = '${saprof.name}/default/${fileshareFolderName3}'


//Create Storage account 1
resource saaib 'Microsoft.Storage/storageAccounts@2020-08-01-preview' = {
  name: storageaccountName1
  location: storageaccountlocation1
  kind: storageaccountkind1  
  sku: {
    name: storgeaccountglobalRedundancy1
  }
}
//Create blob services
resource fssofwtare 'Microsoft.Storage/storageAccounts/blobServices/containers@2020-08-01-preview' = {
  name: filesharelocation1
}
resource fsscripts 'Microsoft.Storage/storageAccounts/blobServices/containers@2020-08-01-preview' = {
  name: filesharelocation2
}

//Create Storage account 2
resource saprof 'Microsoft.Storage/storageAccounts@2020-08-01-preview' = {
  name: storageaccountName2
  location: storageaccountlocation2
  kind: storageaccountkind2
  sku: {
    name: storgeaccountglobalRedundancy2
  }
}
//Create file services
resource fsprofiles 'Microsoft.Storage/storageAccounts/fileServices/shares@2020-08-01-preview' ={
  name: filesharelocation3
  properties: {
    shareQuota: 1000
  }
}


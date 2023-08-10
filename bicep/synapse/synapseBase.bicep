@description('The Azure Region the Synapse workspacw will be deployed to.')
param location string

@description('The name of your Synapse Workspace')
param synapseWorkspaceName string

@description('Name of the Storage Account that deploys by Default with a Synapse Workspace. Used to store some workspace data')
param storageAccountName string

@description('Storage Container in the Storage Account that Synapse will use to write workspace data.')
param storageAccountContainerName string

@description('The name of the Managed Resource Group associated with the Synapse Workspace. (I usually post-fix MRG on the workspace name)')
param synapseWorkspaceNameMRG string



var dataLakeStorageAccountUrl = 'https://${storageAccountName}.dfs.core.windows.net'

resource r_StorageAccount 'Microsoft.Storage/storageAccounts@2022-05-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    isHnsEnabled: true
    supportsHttpsTrafficOnly: true
  }
}

resource r_StorageAccountBlobSvc 'Microsoft.Storage/storageAccounts/blobServices@2022-05-01' = {
  name: 'default'
  parent: r_StorageAccount
}

resource r_StorageAccountContainer 'Microsoft.Storage/storageAccounts/blobServices/containers@2022-05-01' = {
  name: storageAccountContainerName
  parent: r_StorageAccountBlobSvc
  }

resource r_synapseWorkspace 'Microsoft.Synapse/workspaces@2021-06-01' = {
  name: synapseWorkspaceName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    defaultDataLakeStorage: {
      accountUrl: dataLakeStorageAccountUrl
      filesystem: storageAccountContainerName
    }
    managedResourceGroupName: synapseWorkspaceNameMRG
    publicNetworkAccess: 'Enabled'
  }
}

resource r_synapseWorkspaceFirewallAllowAll 'Microsoft.Synapse/workspaces/firewallRules@2021-06-01' = {
  name: 'AllowAllNetworks'
  parent: r_synapseWorkspace
  properties:{
    startIpAddress: '0.0.0.0'
    endIpAddress: '255.255.255.255'
  }
}

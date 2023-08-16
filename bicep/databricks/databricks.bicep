@description('''
Name of the Azure Databricks workspace to create. 
- 3-64 characters
- Alphanumerics, underscores, and hyphens
- Unique to Resource Group
''')
param workspaceName string

@description('Azure Region used for resource deployment.')
param location string = resourceGroup().location

var managedResourceGroupName = 'databricks-rg-${workspaceName}-${uniqueString(workspaceName, resourceGroup().id)}'

resource ws 'Microsoft.Databricks/workspaces@2018-04-01' = {
  name: workspaceName
  location: location
  sku: {
    name: 'premium'
  }
  properties: {
    managedResourceGroupId: managedResourceGroup.id
    parameters: {
      enableNoPublicIp: {
        value: false
      }
    }
  }
}

resource managedResourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' existing = {
  scope: subscription()
  name: managedResourceGroupName
}

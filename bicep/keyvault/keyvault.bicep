@description('''
Name of Azure Key Vault Resource
- Globally Unique
- 3-24 characters
- Alphanumerics and hyphens
- Start with letter. End with letter or digit. 
- Can't contain consecutive hyphens.
''')
param keyVaultName string

@description('Azure Region used for resource deployment.')
param location string = resourceGroup().location

resource symbolicname 'Microsoft.KeyVault/vaults@2022-07-01' = {
  name: keyVaultName
  location: location
  properties: {
    enabledForDeployment: true
    enableSoftDelete: true
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: subscription().tenantId
    accessPolicies:[]
  }
}

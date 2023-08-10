param location string
param databaseName string
param parentClusterName string

resource r_synapseWorkspace 'Microsoft.Kusto/clusters@2022-07-07' existing = {
  name: parentClusterName
}

resource r_KustoDatabase 'Microsoft.Kusto/clusters/databases@2022-07-07' = {
  name: databaseName
  location: location
  kind: 'ReadWrite'
  parent: r_synapseWorkspace
}

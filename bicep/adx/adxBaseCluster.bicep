param dataExplorerResourceName string
param location string


resource r_KustoCluster 'Microsoft.Kusto/clusters@2022-07-07' = {
  name: dataExplorerResourceName
  location: location
  sku: {
    capacity: 2
    name: 'Standard_D11_v2'
    tier: 'Standard'
  }
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    enableAutoStop: true
    enableStreamingIngest: true
  }
}

param synapseWorkspaceName string
param synapseSparkPoolName string
param location string

resource r_synapseWorkspace 'Microsoft.Synapse/workspaces@2021-06-01' existing = {
  name: synapseWorkspaceName
}

resource r_sparkPool 'Microsoft.Synapse/workspaces/bigDataPools@2021-06-01' = {
  name: synapseSparkPoolName
  location: location
  parent: r_synapseWorkspace
  properties: {
    autoPause: {
      delayInMinutes: 30
      enabled: true
    }
    autoScale: {
      enabled: false
    }
    cacheSize: 0
    dynamicExecutorAllocation: {
      enabled: false
    }
    nodeCount: 3
    nodeSize: 'Small'
    nodeSizeFamily: 'MemoryOptimized'
    sparkVersion: '3.3'
  }
}

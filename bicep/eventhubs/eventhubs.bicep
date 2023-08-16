@description('''
Name of the Event Hubs Namespace. 
- Top-Level Naming of Event Hubs 
- 1-50 Characters 
- Alphanumerics, periods, hyphens and underscores.
- Start and end with letter or number
- Globally unique in Azure
''')
param eventHubNamespaceName string

@description('''
Name of the topic receiving/sending events within the Event Hubs Name Space
- Unique to parent Event Hub Namespace
- 1-256 Characters
- Alphanumerics, periods, hyphens and underscores.
- Start and end with letter or number.
''')
param eventHubName string

@description('Azure Region used for resource deployment.')
param location string = resourceGroup().location

var eventHubAP = '${eventHubName}-ap'
var evengHubCG = '${eventHubName}-cg'

resource r_eventHubNamespace 'Microsoft.EventHub/namespaces@2022-01-01-preview' = {
  name: eventHubNamespaceName
  location: location
  sku: {
    capacity: 1
    name: 'Standard'
    tier: 'Standard'
  }
  identity: {
    type: 'SystemAssigned'
  }
}

resource r_eventHub 'Microsoft.EventHub/namespaces/eventhubs@2022-01-01-preview' = {
  name: eventHubName
  parent: r_eventHubNamespace
  properties: {
    messageRetentionInDays: 3
    partitionCount: 8
  }
}

resource r_EventHubAP 'Microsoft.EventHub/namespaces/eventhubs/authorizationRules@2022-01-01-preview' = {
  name: eventHubAP
  parent: r_eventHub
  properties: {
    rights: [
      'Send'
      'Listen'
    ]
  }
}

resource r_EventHubCG 'Microsoft.EventHub/namespaces/eventhubs/consumergroups@2022-01-01-preview' = {
  name: evengHubCG
  parent: r_eventHub
  properties: {
    userMetadata: 'string'
  }
}

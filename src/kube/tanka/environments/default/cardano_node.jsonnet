{
  cardano_node: {
    deployment: $.k.deployment.new('cardano-node', [
      {
        image: 'inputoutput/cardano-node:8.0.0',
        name: 'cardano-node',
        ports: [
          { containerPort: 3001, name: 'default' },
        ],
        env: [
          { name: 'NETWORK', value: 'preview' },
          { name: 'CARDANO_NODE_SOCKET_PATH', value: '/ipc/node.socket' },
        ],
        volumeMounts: [
          { name: 'node-ipc', mountPath: '/ipc' },
          { name: 'datavol', mountPath: '/opt/cardano/data' },
        ],
      },
    ]),
  }
}


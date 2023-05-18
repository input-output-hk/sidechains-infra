local k = import 'k.libsonnet';
{
  substrate_node: {
    deployment: k.deployment.new('substrate-node', [
      {
        image: '689191102645.dkr.ecr.eu-central-1.amazonaws.com/sidechains:v0.0.1',
        name: 'substrate-node',
        ports: [
          { containerPort: 30333, name: 'default-1' },
          { containerPort: 9933, name: 'default-2' },
          { containerPort: 9944, name: 'default-3' },
          { containerPort: 9615, name: 'default-4' },
        ],
        args: [
          "--sidechains-substrate-poc",
          "--base-path",
          "/data/sidechains-substrate-poc",
          "--chain",
          "local",
          "--validator",
          "--node-key",
          "0000000000000000000000000000000000000000000000000000000000000001"
        ],
        volumeMounts: [
          { name: 'chain-data', mountPath: '/chain-data' }
        ],
      },
    ]),
  }
}


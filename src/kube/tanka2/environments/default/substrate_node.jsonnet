local k = import '../../lib/k.libsonnet';
{
  substrate_node: {
    deployment: k.apps.v1.deployment.new('substrate_node', {
      replicas: 1,
      template: {
        spec: {
          containers: [{
            name: 'substrate_node',
            image: '689191102645.dkr.ecr.eu-central-1.amazonaws.com/sidechains:v0.0.1',
            ports: [{ containerPort: 9933, name: 'default' }],
            volumeMounts: [
              { name: 'chain-data', mountPath: '/substrate/chain_data' },
            ],
          }],
          args: [
            '--sidechains-substrate-poc',
            '--base-path',
            '/data/sidechains-substrate-poc',
            '--chain',
            'local',
            '--validator',
            '--node-key',
            '0000000000000000000000000000000000000000000000000000000000000001',
          ],
          volumes: [
            {
              name: 'chain_data',
              emptyDir: {},
            },
          ],
        },
      },
    }),
  },
}

{
  volumes: {
    chain_data: {
      name: 'chain-data',
      emptyDir: {}
    },
    node_ipc: {
      name: 'node-ipc',
      emptyDir: {}
    },
    datavol: {
      name: 'datavol',
      emptyDir: {}
    },
    keys: {
      name: 'keys',
      emptyDir: {}
    },
    postgres_data: {
      name: 'postgres-data',
      emptyDir: {}
    },
    postgres_run: {
      name: 'postgres-run',
      emptyDir: {}
    },
    pgpass: {
      name: 'pgpass',
      configMap: {
        name: 'pgpass'
      }
    },
    vector_config_volume: {
      name: 'vector-config-volume',
      configMap: {
        name: 'vector-config'
      }
    },
    logs: {
      name: 'logs',
      emptyDir: {}
    }
  }
}


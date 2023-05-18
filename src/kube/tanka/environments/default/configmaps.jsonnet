{
  configMaps: {
    pgpass: {
      apiVersion: 'v1',
      kind: 'ConfigMap',
      metadata: {
        name: 'pgpass',
        namespace: 'sidechains-substrate-poc'
      },
      data: {
        pgpass: '/run/postgresql::cexplorer::'
      }
    },
    vector_config: {
      apiVersion: 'v1',
      kind: 'ConfigMap',
      metadata: {
        name: 'vector-config',
        namespace: 'sidechains-substrate-poc'
      },
      data: {
        vector_toml: |||
          [api]
          enabled = true
          address = "0.0.0.0:8686"

          [sources.log_file]
          type = "file"
          include = ["/var/log/*.log"]

          [sinks.prometheus]
          type = "prometheus_exporter"
          inputs = [ "my-source-or-transform-id" ]

          [sinks.console]
          inputs = ["log_file"]
          target = "stdout"
          type = "console"
          encoding.codec = "json"
        |||
      }
    }
  }
}


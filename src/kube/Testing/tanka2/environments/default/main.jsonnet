local k = import "github.com/grafana/jsonnet-libs/ksonnet-util/kausal.libsonnet";

(import "substrate_node.jsonnet") +
{
  _config:: {
    substrate_node: {
      port: 3000,
      name: "substrate_node",
    }
  }
}


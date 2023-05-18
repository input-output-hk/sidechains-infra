(import "substrate-node.jsonnet") +
(import "cardano-node.jsonnet") +
(import "volumes.jsonnet") +
(import "configmaps.jsonnet") +
{
  _config:: {
    substrate-node: {
      port: 3000,
      name: "grafana",
    },
    cardano-node: {
      port: 9090,
      name: "prometheus"
    }
  }
}{}

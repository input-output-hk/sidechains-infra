(import "substrate_node.jsonnet") +
(import "cardano_node.jsonnet") +
(import "volumes.jsonnet") +
(import "configmaps.jsonnet") +
{
  _config:: {
    substrate_node: {
      port: 3000,
      name: "substrate-node",
    },
    cardano_node: {
      port: 9090,
      name: "cardano-node"
    }
  }
}

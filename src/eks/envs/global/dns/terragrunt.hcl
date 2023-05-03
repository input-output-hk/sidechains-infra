include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "git@github.com:input-output-hk/catalyst-tf.git//modules/dns?ref=v1.0.0"
}

inputs = {
  domains = [
    "sc.iog.io"
  ]
}
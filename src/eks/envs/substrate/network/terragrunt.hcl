include "root" {
  path   = find_in_parent_folders()
  expose = true
}

terraform {
  source = "git@github.com:input-output-hk/catalyst-tf.git//modules/network?ref=v1.0.0"
}

inputs = {
  cidr        = "10.0.0.0/16"
  subnet_bits = 8
  azs         = 3
}
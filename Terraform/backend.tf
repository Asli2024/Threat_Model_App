terraform {
  backend "s3" {
    bucket               = "tf-state-bucket-c687c79"
    key                  = "threatcomposer/placeholder.tfstate" # Required; actual workspace states stored under workspace_key_prefix
    region               = "eu-west-2"
    encrypt              = true
    use_lockfile         = true
    workspace_key_prefix = "threatcomposer" # State stored under threatcomposer/<workspace>/terraform.tfstate
  }
}

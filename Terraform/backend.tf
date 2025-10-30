terraform {
  backend "s3" {
    bucket       = "tf-state-bucket-c687c79"
    key          = "threatcomposer/state"
    region       = "eu-west-2"
    encrypt      = true
    use_lockfile = true
  }
}

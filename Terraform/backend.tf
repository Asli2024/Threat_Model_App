terraform {
  backend "s3" {
    bucket               = "english-somali-dictionary-app-dev-s3-l6pk0y"
    key                  = "terraform.tfstate"
    region               = "eu-west-2"
    encrypt              = true
    use_lockfile         = true
    workspace_key_prefix = "engslish-dictionary"
  }
}

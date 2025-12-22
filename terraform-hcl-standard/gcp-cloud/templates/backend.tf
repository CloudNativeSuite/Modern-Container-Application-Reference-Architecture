terraform {
  backend "gcs" {
    bucket = "<replace-with-state-bucket>"
    prefix = "terraform/state"
  }
}

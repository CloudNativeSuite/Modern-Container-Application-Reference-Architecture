variable "name" {
  description = "Name of the KeyPair"
  type        = string
}

variable "public_key" {
  description = "Public key material for AWS KeyPair"
  type        = string
}

variable "tags" {
  description = "Common tags"
  type        = map(string)
}

variable "config_files" {
  description = "Ordered list of config files: [account_config, vpc_config]."
  type        = list(string)
  default     = []
}

variable "vault_domain" {
  type    = string
  default = "https://vault01.honk.digital:8200"
}

variable "vault_cli_domain" {
  type        = string
  default     = "http://localhost:8250"
  description = "DNS hostname or IP address of Vault's CLI."
}

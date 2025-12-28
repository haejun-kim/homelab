variable "proxmox_api_url" {
  description = "Proxmox API endpoint"
  type        = string
}

variable "proxmox_token_id" {
  description = "Proxmox API token ID"
  type        = string
  sensitive   = true
}

variable "proxmox_token_secret" {
  description = "Proxmox API token secret"
  type        = string
  sensitive   = true
}

variable "ssh_key_path" {
  description = "SSH key path"
  type        = string
}

variable "vm_configs" {
  description = "K3s cluster VM definitions"
  type = map(object({
    vmid         = number
    name         = string
    target_node  = string
    cores        = number
    memory       = number
    ipconfig     = string
    gpu          = optional(bool, false)
    data_disk_gb = optional(number, 0)
  }))
}

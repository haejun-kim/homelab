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
    balloon      = optional(number, 0)
    ipconfig     = string
    gpu          = optional(bool, false)
    data_disk_gb = optional(number, 0)
  }))
}

variable "platform_vm_configs" {
  description = "Non-k3s platform VM definitions"
  type = map(object({
    vmid         = number
    name         = string
    target_node  = string
    cores        = number
    memory       = number
    root_disk_gb = number
    ipconfig     = string
    clone        = optional(string, "ubuntu-24.04-template-pve")
    description  = optional(string, "Managed by Terraform.")
  }))
  default = {}
}

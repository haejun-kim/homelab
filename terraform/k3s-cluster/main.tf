resource "proxmox_vm_qemu" "k3s_cluster" {
  for_each = var.vm_configs

  name        = each.value.name
  target_node = each.value.target_node
  vmid        = each.value.vmid
  clone       = "ubuntu-24.04-template"
  full_clone  = true
  agent       = 1

  cpu {
    cores = each.value.cores
    type  = "host"
  }

  memory = each.value.memory

  os_type = "cloud-init"
  bios    = "ovmf"
  scsihw  = "virtio-scsi-single"
  boot    = "order=scsi0;net0"

  machine = "q35"
  balloon = 0

  network {
    id     = 0
    model  = "virtio"
    bridge = "vmbr0"
  }

  efidisk {
    efitype = "4m"
    storage = "local-lvm"
  }

  disk {
    slot    = "ide2"
    type    = "cloudinit"
    storage = "local-lvm"
  }

  disk {
    slot     = "scsi0"
    size     = "32G"
    storage  = "local-lvm"
    type     = "disk"
    iothread = true
    discard  = true
  }

  dynamic "disk" {
    for_each = each.value.data_disk_gb > 0 ? [1] : []
    content {
      slot     = "scsi1"
      size     = "${each.value.data_disk_gb}G"
      storage  = "local-lvm"
      type     = "disk"
      iothread = true
      discard  = true
    }
  }

  dynamic "pci" {
    for_each = each.value.gpu ? [1] : []
    content {
      id = 0
      # datacenter > resource mappings > pci devices add (nvidia)
      # pvesh get /cluster/mapping/pci
      mapping_id = "nvidia-1060"
      rombar    = true
      pcie      = true
    }
  }

  serial {
    id   = 0
    type = "socket"
  }

  ipconfig0 = each.value.ipconfig
  sshkeys   = file(var.ssh_key_path)
  ciuser    = "ubuntu"
}

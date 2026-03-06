output "cce_eip" {
  description = "Public IP (EIP) to manage CCE cluster"
  value = huaweicloud_vpc_eip.cce.address
}

output "elb_eip" {
  description = "Public IP (EIP) for inbound access"
  value = var.create_elb ? one(huaweicloud_vpc_eip.elb).address : "(none)"
}
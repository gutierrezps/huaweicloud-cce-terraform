########################################################################
# VPC and subnet

resource "huaweicloud_vpc" "main" {
  name = "vpc-demo"
  cidr = "10.0.0.0/16"
}

resource "huaweicloud_vpc_subnet" "main" {
  name              = "subnet-demo"
  cidr              = "10.0.0.0/24"
  gateway_ip        = "10.0.0.1"
  vpc_id            = huaweicloud_vpc.main.id
  availability_zone = var.availability_zone
}

########################################################################
# NAT Gateway for outbound internet access

resource "huaweicloud_nat_gateway" "main" {
  name      = "nat-demo"
  spec      = "1"
  vpc_id    = huaweicloud_vpc.main.id
  subnet_id = huaweicloud_vpc_subnet.main.id
}

resource "huaweicloud_vpc_eip" "nat" {
  name = "eip-nat-demo"
  publicip {
    type = "5_bgp"
  }

  bandwidth {
    share_type  = "PER"
    name        = "bandwidth-nat-demo"
    size        = 300
    charge_mode = "traffic"
  }
}

resource "huaweicloud_nat_snat_rule" "main" {
  nat_gateway_id = huaweicloud_nat_gateway.main.id
  floating_ip_id = huaweicloud_vpc_eip.nat.id
  subnet_id      = huaweicloud_vpc_subnet.main.id
}

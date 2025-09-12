########################################################################
# CCE Cluster and Node

resource "huaweicloud_vpc_eip" "cce" {
  name = "eip-cce-kubectl"
  publicip {
    type = "5_bgp"
  }
  bandwidth {
    name        = "bandwidth-eip-cce-kubectl"
    size        = 10
    share_type  = "PER"
    charge_mode = "traffic"
  }
}

resource "huaweicloud_cce_cluster" "main" {
  name                   = "cce-demo"
  flavor_id              = "cce.s1.small"
  vpc_id                 = huaweicloud_vpc.main.id
  subnet_id              = huaweicloud_vpc_subnet.main.id
  container_network_type = "vpc-router"
  cluster_version        = "v1.31"
  container_network_cidr = "10.246.0.0/16"
  service_network_cidr   = "10.247.0.0/16"
  kube_proxy_mode        = "iptables"
  eip                    = huaweicloud_vpc_eip.cce.address
}

# output CCE kubeconfig.json to local file
resource "local_file" "cce_kubeconfig" {
  content  = huaweicloud_cce_cluster.main.kube_config_raw
  filename = "output/kubeconfig.json"
}

resource "huaweicloud_cce_node" "cce_node" {
  cluster_id        = huaweicloud_cce_cluster.main.id
  name              = "cce-node-01"
  flavor_id         = "s6.xlarge.4"
  availability_zone = var.availability_zone
  password          = var.cce_node_password
  subnet_id         = huaweicloud_vpc_subnet.main.id

  root_volume {
    size       = 50
    volumetype = "SAS"
  }
  data_volumes {
    size       = 100
    volumetype = "SAS"
  }
}

########################################################################
# Load Balancer with EIP for inbound access

resource "huaweicloud_lb_loadbalancer" "main" {
  name          = "elb-cce-demo"
  vip_subnet_id = huaweicloud_vpc_subnet.main.ipv4_subnet_id
}

resource "huaweicloud_vpc_eip" "elb" {
  name = "eip-elb-demo"
  publicip {
    type = "5_bgp"
  }

  bandwidth {
    share_type  = "PER"
    name        = "bandwidth-eip-elb-demo"
    size        = 300
    charge_mode = "traffic"
  }
}

resource "huaweicloud_vpc_eip_associate" "elb" {
  public_ip = huaweicloud_vpc_eip.elb.address
  port_id   = huaweicloud_lb_loadbalancer.main.vip_port_id
}

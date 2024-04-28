project_id = ""
region     = ""

## VPC input variables

network_name = ""
subnets = [
  {
    ip_cidr_range = ""
    name          = ""
    region        = ""
  },
  {
    ip_cidr_range = ""
    name          = ""
    region        = ""
  }
]

## Cloud Nat input variables
create_nat = ""

## Cloud HA VPN input variables

create_havpn = false
peer_gateways = {
  default = {
    gcp = "" # e.g. projects/<google-cloud-peer-projectid>/regions/<google-cloud-region>/vpnGateways/<peer-vpn-name>
  }
}

tunnel_1_router_bgp_session_range = ""
tunnel_1_bgp_peer_asn             = 64514
tunnel_1_bgp_peer_ip_address      = ""
tunnel_1_shared_secret            = ""

tunnel_2_router_bgp_session_range = ""
tunnel_2_bgp_peer_asn             = 64514
tunnel_2_bgp_peer_ip_address      = ""
tunnel_2_shared_secret            = ""






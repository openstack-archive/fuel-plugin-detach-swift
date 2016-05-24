notice('MODULAR: openstack-haproxy-swift.pp')

$network_metadata = hiera_hash('network_metadata')
$storage_hash     = hiera_hash('storage', {})
$swift_hash       = hiera_hash('swift_hash', {})
$swift_proxies    = hiera_hash('swift_proxies', undef)
$public_ssl_hash  = hiera('public_ssl')

$swift_proxies_address_map = get_node_to_ipaddr_map_by_network_role($swift_proxies, 'swift/api')

$server_names = hiera_array('swift_proxy_names', keys($swift_proxies_address_map))
$ipaddresses  = hiera_array('swift_proxy_ipaddresses', values($swift_proxies_address_map))

$internal_virtual_ip = $swift_hash['management_vip']
$public_virtual_ip   = $swift_hash['public_vip']

# configure swift haproxy
class { '::openstack::ha::swift':
  internal_virtual_ip => $internal_virtual_ip,
  public_virtual_ip   => $public_virtual_ip,
  ipaddresses         => $ipaddresses,
  server_names        => $server_names,
  public_ssl          => $public_ssl_hash['services'],
}

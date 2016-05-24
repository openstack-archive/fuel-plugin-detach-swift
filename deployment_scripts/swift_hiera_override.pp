notice('MODULAR: detach-swift/swift_hiera_override.pp')

#Plugin variables
$plugin_name         = 'detach-swift'
$detach_swift_plugin = hiera($plugin_name, undef)
$hiera_dir           = '/etc/hiera/override'
$plugin_yaml         = "${plugin_name}.yaml"
$object_role_name    = [ 'standalone-swift-object']
$proxy_role_name     = [ 'standalone-swift-proxy' , 'primary-standalone-swift-proxy']
$corosync_role_name  = [ 'primary-standalone-swift-proxy', 'standalone-swift-proxy']

#Variables from gui
$partition_power = parseyaml($detach_swift_plugin['partition_power'])
$install_on_controllers = ! $detach_swift_plugin['proxy_on_controller_checkbox']

#Variables from hiera
$net_metadata             = hiera_hash('network_metadata')
$nodes_hash               = hiera('nodes')
$hiera_swift_nodes        = hiera('swift_nodes') #This need patch in fuel-library
$hiera_swift_proxies      = get_nodes_hash_by_roles($net_metadata, $proxy_role_name)
$hiera_swift_proxy_caches = hiera('swift_proxy_caches')
$hiera_object_swift_nodes = get_nodes_hash_by_roles($net_metadata, $object_role_name)
$hiera_proxy_swift_nodes  = get_nodes_hash_by_roles($net_metadata, $proxy_role_name)
$hiera_primary_proxy      = get_nodes_hash_by_roles($net_metadata, ['primary-standalone-swift-proxy'])

#Variables for haproxy configuration
$primary_mngt_address = $net_metadata['vips']['proxy_swift_management']['ipaddr']
$primary_pub_address  = $net_metadata['vips']['proxy_swift_public']['ipaddr']

$swift_address_map       = get_node_to_ipaddr_map_by_network_role(get_nodes_hash_by_roles($net_metadata, $proxy_role_name), 'swift/api')
$swift_proxy_nodes_ips   = values($swift_address_map)
$swift_proxy_nodes_names = keys($swift_address_map)

#Check primary something
case hiera('role', 'none')
{
  /standalone-swift-object/:
  {
    $is_primary_swift_proxy = false
    $deploy_swift_storage = true
    $deploy_swift_proxy = false
  }

  /primary-standalone-swift-proxy/:
  {
    if $install_on_controllers
    {
      $is_primary_swift_proxy = false
      $deploy_swift_storage = false
      $deploy_swift_proxy = false
    }
  else
  {
      $is_primary_swift_proxy = true
      $deploy_swift_storage = false
      $deploy_swift_proxy = true
  }
    $corosync_roles = $corosync_role_name
    $corosync_nodes = $hiera_proxy_swift_nodes
    $memcache_roles   = $corosync_role_name
    $memcache_nodes   = $hiera_proxy_swift_nodes
  }

  /standalone-swift-proxy/:
  {
    if $install_on_controllers
    {
      $is_primary_swift_proxy = false
      $deploy_swift_storage = false
      $deploy_swift_proxy = false
    }
    else
    {
      $is_primary_swift_proxy = false
      $deploy_swift_storage = false
      $deploy_swift_proxy = true
    }
    $corosync_roles = $corosync_role_name
    $corosync_nodes = $hiera_proxy_swift_nodes
    $memcache_roles   = $corosync_role_name
    $memcache_nodes   = $hiera_proxy_swift_nodes
  }

  /primary-controller/:
  {
    if $install_on_controllers
    {
      $is_primary_swift_proxy = true
      $deploy_swift_storage = false
      $deploy_swift_proxy = true
    }
    else
    {
      $is_primary_swift_proxy = false
      $deploy_swift_storage = false
      $deploy_swift_proxy = false
    }
  }

  /controller/:
  {
    if $install_on_controllers
    {
      $is_primary_swift_proxy = false
      $deploy_swift_storage = false
      $deploy_swift_proxy = true
    }
    else
    {
      $is_primary_swift_proxy = false
      $deploy_swift_storage = false
      $deploy_swift_proxy = false
    }
  }

  default:
  {
    $is_primary_swift_proxy = false
    $deploy_swift_storage = false
    $deploy_swift_proxy = false
  }
}

$calculated_content = inline_template( '
is_primary_swift_proxy: <%= @is_primary_swift_proxy %>
partition_power: <%= @partition_power %>
deploy_swift_proxy: <%= @deploy_swift_proxy %>
deploy_swift_storage: <%= @deploy_swift_storage %>

<% if @hiera_swift_nodes -%>
<% require "yaml" -%>
swift_nodes:
<%= YAML.dump(@hiera_object_swift_nodes).sub(/--- *$/,"") %>
<% end -%>

<% if !@install_on_controllers -%>
swift_master_role: "primary-standalone-swift-proxy"
swift_hash:
  management_vip: <%= @primary_mngt_address %>
  public_vip: <%= @primary_pub_address %>

<% if @corosync_roles -%>
corosync_roles:
<%
@corosync_roles.each do |crole|
%>  - <%= crole %>
<% end -%>
<% end -%>

<% if @corosync_nodes -%>
<% require "yaml" -%>
corosync_nodes:
<%= YAML.dump(@corosync_nodes).sub(/--- *$/,"") %>
<% end -%>

<% if @memcache_nodes -%>
<% require "yaml" -%>
memcache_nodes:
<%= YAML.dump(@memcache_nodes).sub(/--- *$/,"") %>
<% end -%>
<% if @memcache_roles -%>
memcache_roles:
<%
@memcache_roles.each do |mrole|
%>  - <%= mrole %>
<% end -%>
<% end -%>

<% if @hiera_swift_proxies -%>
<% require "yaml" -%>
swift_proxies:
<%= YAML.dump(@hiera_swift_proxies).sub(/--- *$/,"") %>
<% end -%>

<% if @hiera_swift_proxy_caches -%>
<% require "yaml" -%>
swift_proxy_caches:
<%= YAML.dump(@hiera_swift_proxy_caches).sub(/--- *$/,"") %>
<% end -%>

swift_proxy_ipaddresses:
<% if @swift_proxy_nodes_ips -%>
<%
@swift_proxy_nodes_ips.each do |swiftnode|
%> - <%= swiftnode %>
<% end -%>
<% end -%>

<% if @swift_proxy_nodes_names -%>
swift_proxy_names:
<%
@swift_proxy_nodes_names.each do |swiftnode|
%>  - <%= swiftnode %>
<% end -%>
<% end -%>

<% end -%>
 ')

file {'/etc/hiera/override':
    ensure  => directory,
  } ->
  file { "${hiera_dir}/${plugin_yaml}":
    ensure  => file,
    content => "${calculated_content}\n",
  }

  file_line {"${plugin_name}_hiera_override":
    path  => '/etc/hiera.yaml',
    line  => "  - override/${plugin_name}",
    after => '  - override/module/%{calling_module}',
  }



notice('MODULAR: detach-swift/swift_hiera_override_predeploy.pp')

#Script used for override plugin_name

#Plugin variables
$plugin_name         = 'detach-swift'
$hiera_dir           = '/etc/hiera/override'
$plugin_yaml         = "${plugin_name}_predeploy.yaml"
$detach_swift_plugin = hiera($plugin_name, undef)
$install_on_controllers = ! $detach_swift_plugin['proxy_on_controller_checkbox']

$calculated_content = inline_template( '

<% if !@install_on_controllers -%>
swift_master_role: primary-standalone-swift-proxy
swift_proxy_roles:
  - standalone-swift-proxy
  - primary-standalone-swift-proxy
<% end -%>

swift_object_roles:
  - standalone-swift-object
')

file {'/etc/hiera/override':
    ensure  => directory,
  } ->
  file { "${hiera_dir}/${plugin_yaml}":
    ensure  => file,
    content => "${calculated_content}\n",
  }

  file_line {"${plugin_name}_predeploy":
    path  => '/etc/hiera.yaml',
    line  => "  - override/${plugin_name}_predeploy",
    after => '  - override/module/%{calling_module}',
  }

$plugin_name         = 'detach-swift'
$detach_swift_plugin = hiera($plugin_name, undef)
$install_on_controllers = ! $detach_swift_plugin['proxy_on_controller_checkbox']

if ($install_on_controllers) or (hiera('role') == 'primary-standalone-swift-proxy')
{
  exec { 'update rsyncd':
        command => '/bin/bash /etc/fuel/plugins/*swift*/update_rsyncd.sh',
        path    => '/bin:/usr/bin:/usr/local/bin',
        user    => 'root',
  }
}
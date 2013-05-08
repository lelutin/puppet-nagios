define nagios::plugin (
  $ensure = present,
  $source = 'absent'
) {

  $plugin_path = $::hardwaremodel ? {
    'x86_64' => "/usr/lib64/nagios/plugins/${name}",
    default  => "/usr/lib/nagios/plugins/${name}",
  }
  $real_source = $source ? {
    'absent' => "puppet:///modules/nagios/plugins/${name}",
    default  => "puppet:///modules/${source}"
  }

  file { $name:
    ensure  => $ensure,
    path    => $plugin_path,
    source  => $real_source,
    tag     => 'nagios_plugin',
    owner   => 'root',
    group   => 0,
    mode    => '0755',
    require => Package['nagios-plugins'],
  }

}

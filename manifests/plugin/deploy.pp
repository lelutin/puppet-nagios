define nagios::plugin::deploy (
  $ensure = 'present',
  $source = '',
  $config = '',
  $require_package = 'nagios-plugins'
) {

  $plugin_src = $ensure ? {
    'present' => $name,
    'absent'  => $name,
    default   => $ensure
  }
  $real_source = $source ? {
    ''      => "nagios/plugins/${plugin_src}",
    default => $source
  }

  if !defined(Package[$require_package]) {
    package { $require_package:
      ensure => installed,
      tag    => 'nagios::plugin::deploy::package';
    }
  }

  include nagios::plugin::scriptpaths
  file { "nagios_plugin_${name}":
    path    => "$nagios::plugin::scriptpaths::script_path/${name}",
    source  => "puppet:///modules/${real_source}",
    owner   => 'root',
    group   => 0,
    mode    => '0755',
    require => Package[$require_package],
    tag     => 'nagios::plugin::deploy::file';
  }

  # register the plugin
  nagios::plugin{$name:
    ensure  => $ensure,
    require => Package['nagios-plugins']
  }

}

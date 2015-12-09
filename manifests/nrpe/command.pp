# manage an nrpe command
define nagios::nrpe::command (
  $ensure       = present,
  $command_line = '',
  $source       = '',
){
  if ($command_line == '' and $source == '') {
    fail('Either one of $command_line or $source must be given to nagios::nrpe::command.' )
  }

  $nagios_nrpe_cfgdir = $nagios::nrpe::base::nagios_nrpe_cfgdir

  file{"${nagios_nrpe_cfgdir}/nrpe.d/${name}_command.cfg":
    ensure  => $ensure,
    notify  => Service['nagios-nrpe-server'],
    require => File ["${nagios_nrpe_cfgdir}/nrpe.d" ],
    owner   => 'root',
    group   => 0,
    mode    => '0644';
  }

  case $source {
    '': {
      File["${nagios_nrpe_cfgdir}/nrpe.d/${name}_command.cfg"] {
        content => template('nagios/nrpe/nrpe_command.erb'),
      }
    }
    default: {
      File["${nagios_nrpe_cfgdir}/nrpe.d/${name}_command.cfg"] {
        source => $source,
      }
    }
  }
}

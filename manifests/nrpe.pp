class nagios::nrpe {

  case $::operatingsystem {
    'FreeBSD': {
      if $nagios_nrpe_cfgdir == '' { $nagios_nrpe_cfgdir = '/usr/local/etc' }
      if $nagios_nrpe_pid_file == '' { $nagios_nrpe_pid_file = '/var/spool/nagios/nrpe2.pid' }
      if $nagios_plugin_dir == '' { $nagios_plugin_dir = '/usr/local/libexec/nagios' }

      include nagios::nrpe::freebsd
    }
    default: {
      if $nagios_nrpe_cfgdir == '' { $nagios_nrpe_cfgdir = '/etc/nagios' }
      if $nagios_nrpe_pid_file == '' { $nagios_nrpe_pid_file = '/var/run/nrpe.pid' }
      if $nagios_plugin_dir == '' { $nagios_plugin_dir = '/usr/lib/nagios/plugins' }

      case $::kernel {
        'linux': { include nagios::nrpe::linux }
        default: { include nagios::nrpe::base }
      }
    }
  }

}

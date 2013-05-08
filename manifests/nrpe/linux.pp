class nagios::nrpe::linux inherits nagios::nrpe::base {

    package { [
        'nagios-plugins-standard',
        'ksh',   # for check_cpustats.sh
        'sysstat']:   # for check_cpustats.sh
      ensure => present
    }

}

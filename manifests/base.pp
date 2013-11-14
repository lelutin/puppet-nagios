class nagios::base {
  # include the variables
  include nagios::defaults::vars

  package { 'nagios':
    ensure => present,
    alias  => 'nagios',
  }

  service { 'nagios':
    ensure     => running,
    enable     => true,
    #hasstatus => true, #fixme!
    require    => Package['nagios'],
  }

  # this file should contain all the nagios_puppet-paths:
  file { 'nagios_main_cfg':
    path    => "${nagios::defaults::vars::int_cfgdir}/nagios.cfg",
    source  => ["puppet:///modules/site_nagios/configs/${::fqdn}/nagios.cfg",
                "puppet:///modules/site_nagios/configs/${::operatingsystem}/nagios.cfg",
                'puppet:///modules/site_nagios/configs/nagios.cfg',
                "puppet:///modules/nagios/configs/${::operatingsystem}/nagios.cfg",
                'puppet:///modules/nagios/configs/nagios.cfg'],
    owner   => 'root',
    group   => 0,
    mode    => '0644',
    require => Package['nagios'],
    notify  => Service['nagios'],
  }

  file { 'nagios_cgi_cfg':
    path    => "${nagios::defaults::vars::int_cfgdir}/cgi.cfg",
    source  => ["puppet:///modules/site_nagios/configs/${::fqdn}/cgi.cfg",
                "puppet:///modules/site_nagios/configs/${::operatingsystem}/cgi.cfg",
                'puppet:///modules/site_nagios/configs/cgi.cfg',
                "puppet:///modules/nagios/configs/${::operatingsystem}/cgi.cfg",
                'puppet:///modules/nagios/configs/cgi.cfg'],
    owner   => 'root',
    group   => 0,
    mode    => '0644',
    require => Package['nagios'],
    notify  => Service['apache'],
  }

  file { 'nagios_htpasswd':
    path    => "${nagios::defaults::vars::int_cfgdir}/htpasswd.users",
    source  => ['puppet:///modules/site_nagios/htpasswd.users',
                'puppet:///modules/nagios/htpasswd.users'],
    owner   => 'root',
    group   => 'apache',
    mode    => '0640',
    require => Package['nagios'],
  }

  file { 'nagios_private':
    ensure  => directory,
    path    => "${nagios::defaults::vars::int_cfgdir}/private/",
    purge   => true,
    recurse => true,
    owner   => 'root',
    group   => 'nagios',
    mode    => '0750',
    require => Package['nagios'],
    notify  => Service['nagios'],
  }

  file { 'nagios_private_resource_cfg':
    path    => "${nagios::defaults::vars::int_cfgdir}/private/resource.cfg",
    source  => ["puppet:///modules/site_nagios/configs/${::operatingsystem}/private/resource.cfg.${::architecture}",
                "puppet:///modules/nagios/configs/${::operatingsystem}/private/resource.cfg.${::architecture}"],
    owner   => 'root',
    group   => 'nagios',
    mode    => '0640',
    require => Package['nagios'],
    notify  => Service['nagios'],
  }

  file { 'nagios_confd':
    ensure  => directory,
    path    => "${nagios::defaults::vars::int_cfgdir}/conf.d/",
    purge   => true,
    recurse => true,
    owner   => 'root',
    group   => 'nagios',
    mode    => '0750',
    require => Package['nagios'],
    notify  => Service['nagios'],
  }
  Nagios_command <<||>>
  Nagios_contactgroup <<||>>
  Nagios_contact <<||>>
  Nagios_hostdependency <<||>>
  Nagios_hostescalation <<||>>
  Nagios_hostextinfo <<||>>
  Nagios_hostgroup <<||>>
  Nagios_host <<||>>
  Nagios_servicedependency <<||>>
  Nagios_serviceescalation <<||>>
  Nagios_servicegroup <<||>>
  Nagios_serviceextinfo <<||>>
  Nagios_service <<||>>
  Nagios_timeperiod <<||>>

  Nagios_command <||> {
    target  => "${nagios::defaults::vars::int_cfgdir}/conf.d/nagios_command.cfg",
    require => File['nagios_confd'],
    notify  => Service['nagios'],
  }
  Nagios_contact <||> {
    target  => "${nagios::defaults::vars::int_cfgdir}/conf.d/nagios_contact.cfg",
    require => File['nagios_confd'],
    notify  => Service['nagios'],
  }
  Nagios_contactgroup <||> {
    target  => "${nagios::defaults::vars::int_cfgdir}/conf.d/nagios_contactgroup.cfg",
    require => File['nagios_confd'],
    notify  => Service['nagios'],
  }
  Nagios_host <||> {
    target  => "${nagios::defaults::vars::int_cfgdir}/conf.d/nagios_host.cfg",
    require => File['nagios_confd'],
    notify  => Service['nagios'],
  }
  Nagios_hostdependency <||> {
    target => "${nagios::defaults::vars::int_cfgdir}/conf.d/nagios_hostdependency.cfg",
    notify => Service['nagios'],
  }
  Nagios_hostescalation <||> {
    target => "${nagios::defaults::vars::int_cfgdir}/conf.d/nagios_hostescalation.cfg",
    notify => Service['nagios'],
  }
  Nagios_hostextinfo <||> {
    target  => "${nagios::defaults::vars::int_cfgdir}/conf.d/nagios_hostextinfo.cfg",
    require => File['nagios_confd'],
    notify  => Service['nagios'],
  }
  Nagios_hostgroup <||> {
    target  => "${nagios::defaults::vars::int_cfgdir}/conf.d/nagios_hostgroup.cfg",
    require => File['nagios_confd'],
    notify  => Service['nagios'],
  }
  Nagios_service <||> {
    target  => "${nagios::defaults::vars::int_cfgdir}/conf.d/nagios_service.cfg",
    require => File['nagios_confd'],
    notify  => Service['nagios'],
  }
  Nagios_servicegroup <||> {
    target => "${nagios::defaults::vars::int_cfgdir}/conf.d/nagios_servicegroup.cfg",
    notify => Service['nagios'],
  }
  Nagios_servicedependency <||> {
    target  => "${nagios::defaults::vars::int_cfgdir}/conf.d/nagios_servicedependency.cfg",
    require => File['nagios_confd'],
    notify  => Service['nagios'],
  }
  Nagios_serviceescalation <||> {
    target  => "${nagios::defaults::vars::int_cfgdir}/conf.d/nagios_serviceescalation.cfg",
    require => File['nagios_confd'],
    notify  => Service['nagios'],
  }
  Nagios_serviceextinfo <||> {
    target  => "${nagios::defaults::vars::int_cfgdir}/conf.d/nagios_serviceextinfo.cfg",
    require => File['nagios_confd'],
    notify  => Service['nagios'],
  }
  Nagios_timeperiod <||> {
    target  => "${nagios::defaults::vars::int_cfgdir}/conf.d/nagios_timeperiod.cfg",
    require => File['nagios_confd'],
    notify  => Service['nagios'],
  }

  file{["${nagios::defaults::vars::int_cfgdir}/conf.d/nagios_command.cfg",
        "${nagios::defaults::vars::int_cfgdir}/conf.d/nagios_contact.cfg",
        "${nagios::defaults::vars::int_cfgdir}/conf.d/nagios_contactgroup.cfg",
        "${nagios::defaults::vars::int_cfgdir}/conf.d/nagios_host.cfg",
        "${nagios::defaults::vars::int_cfgdir}/conf.d/nagios_hostdependency.cfg",
        "${nagios::defaults::vars::int_cfgdir}/conf.d/nagios_hostescalation.cfg",
        "${nagios::defaults::vars::int_cfgdir}/conf.d/nagios_hostextinfo.cfg",
        "${nagios::defaults::vars::int_cfgdir}/conf.d/nagios_hostgroup.cfg",
        "${nagios::defaults::vars::int_cfgdir}/conf.d/nagios_hostgroupescalation.cfg",
        "${nagios::defaults::vars::int_cfgdir}/conf.d/nagios_service.cfg",
        "${nagios::defaults::vars::int_cfgdir}/conf.d/nagios_servicedependency.cfg",
        "${nagios::defaults::vars::int_cfgdir}/conf.d/nagios_serviceescalation.cfg",
        "${nagios::defaults::vars::int_cfgdir}/conf.d/nagios_serviceextinfo.cfg",
        "${nagios::defaults::vars::int_cfgdir}/conf.d/nagios_servicegroup.cfg",
        "${nagios::defaults::vars::int_cfgdir}/conf.d/nagios_timeperiod.cfg" ]:
    ensure  => file,
    replace => false,
    owner   => 'root',
    group   => 0,
    mode    => '0644',
    require => File['nagios_confd'],
    notify  => Service['nagios'],
  }

  # manage nagios cfg files
  # must be defined after exported resource overrides and cfg file defs
  file { 'nagios_cfgdir':
    ensure  => directory,
    path    => "${nagios::defaults::vars::int_cfgdir}/",
    recurse => true,
    purge   => true,
    owner   => 'root',
    group   => 0,
    mode    => '0755',
    require => Package['nagios'],
    notify  => Service['nagios'],
  }
}

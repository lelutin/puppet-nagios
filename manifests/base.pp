# basic stuff for nagios
class nagios::base {
  # include the variables
  include nagios::defaults::vars

  package { 'nagios':
    ensure  => present,
  }

  service { 'nagios':
    ensure  => running,
    enable  => $nagios::service_at_boot,
    #hasstatus => true, #fixme!
    require => Package['nagios'],
  }

  $cfg_dir = $nagios::defaults::vars::int_cfgdir
  # this file should contain all the nagios_puppet-paths:
  file{
    'nagios_main_cfg':
      path    => "${cfg_dir}/nagios.cfg",
      source  => ["puppet:///modules/site_nagios/configs/${::fqdn}/nagios.cfg",
                  "puppet:///modules/site_nagios/configs/${::operatingsystem}/nagios.cfg",
                  'puppet:///modules/site_nagios/configs/nagios.cfg',
                  "puppet:///modules/nagios/configs/${::operatingsystem}/nagios.cfg",
                  'puppet:///modules/nagios/configs/nagios.cfg' ],
      notify  => Service['nagios'],
      owner   => root,
      group   => root,
      mode    => '0644';
    'nagios_cgi_cfg':
      path    => "${cfg_dir}/cgi.cfg",
      source  => [ "puppet:///modules/site_nagios/configs/${::fqdn}/cgi.cfg",
                  "puppet:///modules/site_nagios/configs/${::operatingsystem}/cgi.cfg",
                  'puppet:///modules/site_nagios/configs/cgi.cfg',
                  "puppet:///modules/nagios/configs/${::operatingsystem}/cgi.cfg",
                  'puppet:///modules/nagios/configs/cgi.cfg' ],
      notify  => Service['apache'],
      owner   => 'root',
      group   => 0,
      mode    => '0644';
    'nagios_htpasswd':
      path    => "${cfg_dir}/htpasswd.users",
      source  => ['puppet:///modules/site_nagios/htpasswd.users',
                  'puppet:///modules/nagios/htpasswd.users' ],
      owner   => root,
      group   => apache,
      mode    => '0640';
    'nagios_private':
      ensure  => directory,
      path    => "${cfg_dir}/private",
      purge   => true,
      recurse => true,
      notify  => Service['nagios'],
      owner   => root,
      group   => nagios,
      mode    => '0750';
    'nagios_private_resource_cfg':
      path    => "${cfg_dir}/private/resource.cfg",
      source  => [ "puppet:///modules/site_nagios/configs/${::operatingsystem}/private/resource.cfg.${::architecture}",
                  "puppet:///modules/nagios/configs/${::operatingsystem}/private/resource.cfg.${::architecture}" ],
      notify  => Service['nagios'],
      owner   => root,
      group   => nagios,
      mode    => '0640';
    'nagios_confd':
      ensure  => directory,
      path    => "${cfg_dir}/conf.d",
      purge   => true,
      recurse => true,
      notify  => Service['nagios'],
      owner   => root,
      group   => nagios,
      mode    => '0750';
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
  if $nagios::purge_resources {
    resources {
      [
        'nagios_command',
        'nagios_contactgroup',
        'nagios_contact',
        'nagios_hostdependency',
        'nagios_hostescalation',
        'nagios_hostextinfo',
        'nagios_hostgroup',
        'nagios_host',
        'nagios_servicedependency',
        'nagios_serviceescalation',
        'nagios_servicegroup',
        'nagios_serviceextinfo',
        'nagios_service',
        'nagios_timeperiod',
      ]:
        purge => true;
    }
  }

  Nagios_command <||> {
    target  => "${cfg_dir}/conf.d/nagios_command.cfg",
    require => File['nagios_confd'],
    notify  => Service['nagios'],
  }
  Nagios_contact <||> {
    target  => "${cfg_dir}/conf.d/nagios_contact.cfg",
    require => File['nagios_confd'],
    notify  => Service['nagios'],
  }
  Nagios_contactgroup <||> {
    target  => "${cfg_dir}/conf.d/nagios_contactgroup.cfg",
    require => File['nagios_confd'],
    notify  => Service['nagios'],
  }
  Nagios_host <||> {
    target  => "${cfg_dir}/conf.d/nagios_host.cfg",
    require => File['nagios_confd'],
    notify  => Service['nagios'],
  }
  Nagios_hostdependency <||> {
    target  => "${cfg_dir}/conf.d/nagios_hostdependency.cfg",
    notify  => Service['nagios'],
  }
  Nagios_hostescalation <||> {
    target  => "${cfg_dir}/conf.d/nagios_hostescalation.cfg",
    notify  => Service['nagios'],
  }
  Nagios_hostextinfo <||> {
    target  => "${cfg_dir}/conf.d/nagios_hostextinfo.cfg",
    require => File['nagios_confd'],
    notify  => Service['nagios'],
  }
  Nagios_hostgroup <||> {
    target  => "${cfg_dir}/conf.d/nagios_hostgroup.cfg",
    require => File['nagios_confd'],
    notify  => Service['nagios'],
  }
  Nagios_service <||> {
    target  => "${cfg_dir}/conf.d/nagios_service.cfg",
    require => File['nagios_confd'],
    notify  => Service['nagios'],
  }
  Nagios_servicegroup <||> {
    target  => "${cfg_dir}/conf.d/nagios_servicegroup.cfg",
    notify  => Service['nagios'],
  }
  Nagios_servicedependency <||> {
    target  => "${cfg_dir}/conf.d/nagios_servicedependency.cfg",
    require => File['nagios_confd'],
    notify  => Service['nagios'],
  }
  Nagios_serviceescalation <||> {
    target  => "${cfg_dir}/conf.d/nagios_serviceescalation.cfg",
    require => File['nagios_confd'],
    notify  => Service['nagios'],
  }
  Nagios_serviceextinfo <||> {
    target  => "${cfg_dir}/conf.d/nagios_serviceextinfo.cfg",
    require => File['nagios_confd'],
    notify  => Service['nagios'],
  }
  Nagios_timeperiod <||> {
    target  => "${cfg_dir}/conf.d/nagios_timeperiod.cfg",
    require => File['nagios_confd'],
    notify  => Service['nagios'],
  }

  file{
    # manage nagios cfg files
    # must be defined after exported resource overrides and cfg file defs
    'nagios_cfgdir':
      ensure  => directory,
      path    => $cfg_dir,
      recurse => true,
      purge   => true,
      force   => true,
      notify  => Service['nagios'],
      owner   => root,
      group   => root,
      mode    => '0755';
    ["${cfg_dir}/conf.d/nagios_command.cfg",
    "${cfg_dir}/conf.d/nagios_contact.cfg",
    "${cfg_dir}/conf.d/nagios_contactgroup.cfg",
    "${cfg_dir}/conf.d/nagios_host.cfg",
    "${cfg_dir}/conf.d/nagios_hostdependency.cfg",
    "${cfg_dir}/conf.d/nagios_hostescalation.cfg",
    "${cfg_dir}/conf.d/nagios_hostextinfo.cfg",
    "${cfg_dir}/conf.d/nagios_hostgroup.cfg",
    "${cfg_dir}/conf.d/nagios_hostgroupescalation.cfg",
    "${cfg_dir}/conf.d/nagios_service.cfg",
    "${cfg_dir}/conf.d/nagios_servicedependency.cfg",
    "${cfg_dir}/conf.d/nagios_serviceescalation.cfg",
    "${cfg_dir}/conf.d/nagios_serviceextinfo.cfg",
    "${cfg_dir}/conf.d/nagios_servicegroup.cfg",
    "${cfg_dir}/conf.d/nagios_timeperiod.cfg" ]:
      ensure  => file,
      replace => false,
      notify  => Service['nagios'],
      owner   => root,
      group   => 0,
      mode    => '0644';
    # unfortuantely resource purging only works on the default path and
    # because we changed it above -> link the default path
    "${cfg_dir}/nagios_command.cfg":
      ensure => link,
      target => "${cfg_dir}/conf.d/nagios_command.cfg";
    "${cfg_dir}/nagios_contact.cfg":
      ensure => link,
      target => "${cfg_dir}/conf.d/nagios_contact.cfg";
    "${cfg_dir}/nagios_contactgroup.cfg":
      ensure => link,
      target => "${cfg_dir}/conf.d/nagios_contactgroup.cfg";
    "${cfg_dir}/nagios_host.cfg":
      ensure => link,
      target => "${cfg_dir}/conf.d/nagios_host.cfg";
    "${cfg_dir}/nagios_hostdependency.cfg":
      ensure => link,
      target => "${cfg_dir}/conf.d/nagios_hostdependency.cfg";
    "${cfg_dir}/nagios_hostescalation.cfg":
      ensure => link,
      target => "${cfg_dir}/conf.d/nagios_hostescalation.cfg";
    "${cfg_dir}/nagios_hostextinfo.cfg":
      ensure => link,
      target => "${cfg_dir}/conf.d/nagios_hostextinfo.cfg";
    "${cfg_dir}/nagios_hostgroup.cfg":
      ensure => link,
      target => "${cfg_dir}/conf.d/nagios_hostgroup.cfg";
    "${cfg_dir}/nagios_hostgroupescalation.cfg":
      ensure => link,
      target => "${cfg_dir}/conf.d/nagios_hostgroupescalation.cfg";
    "${cfg_dir}/nagios_service.cfg":
      ensure => link,
      target => "${cfg_dir}/conf.d/nagios_service.cfg";
    "${cfg_dir}/nagios_servicedependency.cfg":
      ensure => link,
      target => "${cfg_dir}/conf.d/nagios_servicedependency.cfg";
    "${cfg_dir}/nagios_serviceescalation.cfg":
      ensure => link,
      target => "${cfg_dir}/conf.d/nagios_serviceescalation.cfg";
    "${cfg_dir}/nagios_serviceextinfo.cfg":
      ensure => link,
      target => "${cfg_dir}/conf.d/nagios_serviceextinfo.cfg";
    "${cfg_dir}/nagios_servicegroup.cfg":
      ensure => link,
      target => "${cfg_dir}/conf.d/nagios_servicegroup.cfg";
    "${cfg_dir}/nagios_timeperiod.cfg":
      ensure => link,
      target => "${cfg_dir}/conf.d/nagios_timeperiod.cfg";
  }
}

class nagios::debian (
  $package_name
) inherits nagios::base {

  if $nagios::use_icinga {
    file { '/var/lib/nagios3':
      ensure => link,
      target => '/var/lib/icinga',
    }
    file { 'nagios_init_script':
      path   => '/etc/init.d/icinga',
      source => [ "puppet:///modules/nagios/configs/Debian/icinga/icinga-init-script" ],
      owner  => 'root',
      group  => 0,
      mode   => '0755',
      notify => Service['nagios'],
    }

    # icinga creates a symlink at /etc/apache/conf.d to this file
    file { 'icinga-apache-config':
      path   => '/etc/icinga/apache2.conf',
      source => [ "puppet:///modules/site-nagios/configs/Debian/icinga/apache2.conf" ,
                  "puppet:///modules/nagios/configs/Debian/icinga/apache2.conf" ],
      notify => Service['apache'],
      owner  => 'root',
      group  => 0,
      mode   => '0644',
    }

  }

  Package['nagios'] { name => $package_name }
  Service['nagios'] {
    name      => $package_name,
    hasstatus => true,
  }

  package { [ 'nagios-plugins', 'nagios-snmp-plugins','nagios-nrpe-plugin' ]:
    ensure => present,
    notify => Service['nagios'],
  }


  File['nagios_htpasswd', 'nagios_cgi_cfg'] { group => 'www-data' }

  file { 'nagios_commands_cfg':
    ensure => present,
    path   => "${nagios::defaults::vars::int_cfgdir}/commands.cfg",
    owner  => 'root',
    group  => 0,
    mode   => '0644',
    notify => Service['nagios'],
  }

  file { "${nagios::defaults::vars::int_cfgdir}/stylesheets":
    ensure  => directory,
    purge   => false,
    recurse => true,
  }

  if $nagios::allow_external_cmd {
    exec { 'nagios_external_cmd_perms_overrides':
      command   => 'dpkg-statoverride --update --add nagios www-data 2710 /var/lib/nagios3/rw && dpkg-statoverride --update --add nagios nagios 751 /var/lib/nagios3',
      unless    => 'dpkg-statoverride --list nagios www-data 2710 /var/lib/nagios3/rw && dpkg-statoverride --list nagios nagios 751 /var/lib/nagios3',
      logoutput => false,
      notify    => Service['nagios'],
    }
    exec { 'nagios_external_cmd_perms_1':
      command => 'chmod 0751 /var/lib/nagios3 && chown nagios:nagios /var/lib/nagios3',
      unless  => 'test "`stat -c "%a %U %G" /var/lib/nagios3`" = "751 nagios nagios"',
      notify  => Service['nagios'],
    }
    exec { 'nagios_external_cmd_perms_2':
      command => 'chmod 2751 /var/lib/nagios3/rw && chown nagios:www-data /var/lib/nagios3/rw',
      unless  => 'test "`stat -c "%a %U %G" /var/lib/nagios3/rw`" = "2751 nagios www-data"',
      notify  => Service['nagios'],
    }
  }
}

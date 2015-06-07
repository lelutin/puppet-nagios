# a simple nagios target to monitor
class nagios::target(
  $parents      = 'absent',
  $address      = $::ipaddress,
  $nagios_alias = $::hostname,
  $hostgroups   = 'absent',
  $use          = 'generic-host',
){
  @@nagios_host { $::fqdn:
    address => $address,
    alias   => $nagios_alias,
    use     => $use,
  }

  if ($parents != 'absent') {
    Nagios_host[$::fqdn] {
      parents => $parents
    }
  }

  if ($hostgroups != 'absent') {
    Nagios_host[$::fqdn] {
      hostgroups => $hostgroups
    }
  }
}

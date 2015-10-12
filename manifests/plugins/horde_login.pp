# check_horde_login
class nagios::plugins::horde_login {
  nagios::plugin { 'check_horde_login':
    source => 'nagios/plugins/check_horde_login',
  } -> nagios_command {
    'check_horde_login':
      command_line => "\$USER1\$/check_horde_login -s \$ARG1\$ -u \$ARG2\$ -p \$ARG3\$",
  }
}

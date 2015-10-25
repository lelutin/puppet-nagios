# a simple imap login check
class nagios::plugins::imap_login {
  nagios::plugin { 'check_imap_login':
    source => 'nagios/plugins/check_imap_login',
  }
}


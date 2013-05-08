class nagios::irc_bot(
  $nsa_server,
  $nsa_nickname,
  $nsa_channel,
  $nsa_socket = 'absent',
  $nsa_port = 6667,
  $nsa_password = '',
  $nsa_pidfile = 'absent',
  $nsa_realname = 'Nagios',
  $nsa_usenotices = false,
  $nsa_commandfile = 'absent'
) {
  $socket_path = $::operatingsystem ? {
    'centos' => '/var/run/nagios-nsa/nsa.socket',
    default  => '/var/run/nagios3/nsa.socket'
  }
  $real_nsa_socket = $nsa_socket ? {
    'absent' => $socket_path,
    default  => $nsa_socket,
  }

  $pid_path = $::operatingsystem ? {
    'centos' => '/var/run/nagios-nsa/nsa.pid',
    default  => '/var/run/nagios3/nsa.pid'
  }
  $real_nsa_pidfile = $nsa_pidfile ? {
    'absent' => $pid_path,
    default  => $nsa_pidfile,
  }

  $cmdfile_path = $::operatingsystem ? {
    'centos' => '/var/spool/nagios/cmd/nagios.cmd',
    default  => '/var/lib/nagios3/rw/nagios.cmd'
  }
  $real_nsa_commandfile = $nsa_commandfile ? {
    'absent' => $cmdfile_path,
    default  => $nsa_commandfile,
  }

  case $::operatingsystem {
    centos: {
      include nagios::irc_bot::centos
    }
    debian,ubuntu: {
      include nagios::irc_bot::debian
    }
    default: {
      include nagios::irc_bot::base
    }
  }

  if $nagios::manage_shorewall {
    include shorewall::rules::out::irc
  }
}

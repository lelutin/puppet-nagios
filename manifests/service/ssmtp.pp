define nagios::service::ssmtp (
  $ensure = 'present',
  $host = 'absent',
  $port = '465',
  $cert_days = 10
) {

  $real_host = $host ? {
    'absent' => $name,
    default  => $host
  }
  $real_cert_days = $cert_days ? {
    'absent' => 'absent',
    default  => $ensure
  }

  nagios::service {
    "ssmtp_${name}_${port}":
      ensure => $ensure;
    "ssmtp_cert_${name}_${port}":
      ensure => $real_cert_days;
  }

  if $ensure != 'absent' {
    Nagios::Service["ssmtp_${name}_${port}"] {
      check_command => "check_ssmtp!${real_host}!${port}",
    }
    if $cert_days != 'absent' {
      Nagios::Service["ssmtp_cert_${name}_${port}"] {
        check_command => "check_ssmtp_cert!${real_host}!${port}!${cert_days}",
      }
    }
  }

}

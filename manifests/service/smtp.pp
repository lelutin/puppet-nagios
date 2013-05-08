# true:
#   - true   : check tls and plain connect *defualt*
#   - false : check plain connection only
# cert_days:
#   If tls is used add an additionl check
#   to check for validity for cert.
#   - 'absent' : do not execute that check
#   - INTEGER  : Minimum number of days a certificate
#                has to be valid. Default: 10
define nagios::service::smtp (
  $ensure = 'present',
  $host = 'absent',
  $port = '25',
  $tls = true,
  $cert_days = 10
) {

  $real_host = $host ? {
    'absent' => $name,
    default  => $host
  }
  $real_tls = $tls ? {
    true    => $ensure,
    default => 'absent'
  }
  $real_cert_days = $cert_days ? {
    'absent' => 'absent',
    default  => $ensure
  }

  nagios::service {
    "smtp_${name}_${port}":
      ensure => $ensure;
    "smtp_tls_${name}_${port}":
      ensure => $real_tls;
    "smtp_tls_cert_${name}_${port}":
      ensure => $real_cert_days;
  }

  if $ensure != 'absent' {
    Nagios::Service["smtp_${name}_${port}"] {
      check_command => "check_smtp!${real_host}!${port}",
    }
    Nagios::Service["smtp_tls_${name}_${port}"] {
      check_command => "check_smtp_tls!${real_host}!${port}",
    }
    if $cert_days != 'absent' {
      Nagios::Service["smtp_tls_cert_${name}_${port}"] {
        check_command => "check_smtp_cert!${real_host}!${port}!${cert_days}",
      }
    }
  }

}

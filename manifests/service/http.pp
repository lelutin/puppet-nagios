# ssl_mode:
#   - false: only check http
#   - true: check http and https
#   - force: http is permanent redirect to https
#   - only: check only https
define nagios::service::http (
  $ensure = present,
  $check_domain = 'absent',
  $port = '80',
  $check_url = '/',
  $check_code = 'OK',
  $use = 'generic-service',
  $ssl_mode = false
){

  $real_check_domain = $check_domain ? {
    'absent' => $name,
    default  => $check_domain
  }
  if ($ssl_mode == 'force') or ($ssl_mode == true)
      or ($ssl_mode =='only')
  {
    nagios::service { "https_${name}_${check_code}":
      ensure        => $ensure,
      use           => $use,
      check_command => "check_https_url_regex!${real_check_domain}!${check_url}!'${check_code}'",
    }
    if $ssl_mode == 'force' {
      nagios::service{"httprd_${name}":
        ensure        => $ensure,
        use           => $use,
        check_command => "check_http_url_regex!${real_check_domain}!${port}!${check_url}!'301'",
      }
    }
  }
  if ($ssl_mode == false) or ($ssl_mode == true) {
    nagios::service{"http_${name}_${check_code}":
      ensure        => $ensure,
      use           => $use,
      check_command => "check_http_url_regex!${real_check_domain}!${port}!${check_url}!'${check_code}'",
    }
  }

}

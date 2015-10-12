# define a gpgkey to be watched
define nagios::service::gpgkey(
  $ensure   = 'present',
  $warning  = '14',
  $key_info = undef,
){
  validate_slength($name,40,40)
  require ::nagios::plugins::gpg
  $gpg_home = $nagios::plugins::gpg::gpg_home

  exec{"manage_key_${name}":
    user  => nagios,
    group => nagios,
  }
  nagios::service{
    "check_gpg_${name}":
      ensure => $ensure;
  }

  if $ensure == 'present' {
    Exec["manage_key_${name}"]{
      command => "gpg --homedir ${gpg_home} --recv-keys ${name}",
      unless  => "gpg --homedir ${gpg_home} --list-keys ${name}",
      before  => Nagios::Service["check_gpg_${name}"],
    }

    Nagios::Service["check_gpg_${name}"]{
      check_command => "check_gpg!${warning}!${name}",
    }
    if $key_info {
      Nagios::Service["check_gpg_${name}"]{
        service_description => "Keyfingerprint: ${name} - Info: ${key_info}",
      }
    } else {
      Nagios::Service["check_gpg_${name}"]{
        service_description => "Keyfingerprint: ${name}",
      }
    }
  } else {
    Exec["manage_key_${name}"]{
      command => "gpg --batch --homedir ${gpg_home} --delete-key ${name}",
      onlyif  => "gpg --homedir ${gpg_home} --list-keys ${name}",
      require => Nagios::Service["check_gpg_${name}"],
    }
  }
}

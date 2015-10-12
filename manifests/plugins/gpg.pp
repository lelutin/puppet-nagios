# check_gpg from
# https://github.com/lelutin/nagios-plugins/blob/master/check_gpg
class nagios::plugins::gpg {
  require ::gnupg
  nagios::plugin{'check_gpg':
    source => 'nagios/plugins/check_gpg',
  }

  $gpg_home = '/var/local/nagios_gpg_homedir'
  file{
    $gpg_home:
      ensure  => 'directory',
      owner   => nagios,
      group   => nagios,
      mode    => '0600',
      require => Nagios::Plugin['check_gpg'];
    '/etc/cron.daily/update_nagios_gpgkeys':
      content => "!#/bin/bash
function exec() {
  cmd=\$1
  outout=\$(su - nagios -s /bin/bash -c 'gpg --homedir ${gpg_home} --logger-fd 1 \${cmd}')
  if [ \$? -gt 0 ]; then
   echo \$output
   exit 1
  fi
}

gpg('--with-fingerprint --list-keys --with-colons') | grep \"^pub\" -A 1 | tail -n 1 | cut -f10 -d\":\" | sort --random-sort | while read key; do
  gpg(\"--recv-keys \${key}\")
done
",
      owner   => root,
      group   => 0,
      mode    => '0700',
      require => File[$gpg_home];
  }
  nagios_command {
    'check_gnupg':
      command_line => "\$USER1\$/check_gpg --gnupg-homedir ${gpg_home} -w \$ARG1\$ \$ARG2\$",
      require      => Nagios::Plugin['check_gpg'],
  }
}


class nagios::nrpe::base {

    if $nagios_nrpe_cfgdir == '' { $nagios_nrpe_cfgdir = '/etc/nagios' }
    if $nagios_nrpe_dont_blame == '' { $nagios_nrpe_dont_blame = 1 }
    
    package { 	"nagios-nrpe-server": ensure => present;
		    "nagios-plugins-basic": ensure => present;
		    "libnagios-plugin-perl": ensure => present;
		    "libwww-perl": ensure => present;   # for check_apache
	    }

    
    file { [ $nagios_nrpe_cfgdir, "$nagios_nrpe_cfgdir/nrpe.d" ]: 
	ensure => directory }

    file { "$nagios_nrpe_cfgdir/nrpe.cfg":
	    content => template('nagios/nrpe/nrpe.cfg'),
	    owner => root, group => root, mode => 644;
    }
    
    # default commands
    nagios::nrpe::command { "basic_nrpe":
        source => [ "puppet:///modules/site-nagios/configs/nrpe/nrpe_commands.cfg",
                    "puppet:///modules/nagios/nrpe/nrpe_commands.cfg" ],
    }

    service { "nagios-nrpe-server":
	    ensure    => running,
	    enable    => true,
	    pattern   => "nrpe",
	    subscribe => File["$nagios_nrpe_cfgdir/nrpe.cfg"]
    }
}

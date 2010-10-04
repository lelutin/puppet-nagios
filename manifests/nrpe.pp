class nagios::nrpe {

    if $nagios_nrpe_cfgdir == '' { $nagios_nrpe_cfgdir = '/etc/nagios' }
    
    #$real_nagios_nrpe_cfgdir = $nagios_nrpe_cfgdir ? {
    #    '' => '/etc/nagios',
    #    default => $nagios_nrpe_cfgdir
    #}

	package { 	"nagios-nrpe-server": ensure => latest;
			"nagios-plugins-basic": ensure => latest;
			"nagios-plugins-standard": ensure => latest;
			"libnagios-plugin-perl": ensure => present;
			"libwww-perl": ensure => present;   # für check_apache
			"ksh": ensure => present; # für check_cpustats.sh
			"sysstat": ensure => present; # für check_cpustats.sh
		}

	
	file { [ $nagios_nrpe_cfgdir, "$nagios_nrpe_cfgdir/nrpe.d" ]: 
	    ensure => directory }

	file { "$nagios_nrpe_cfgdir/nrpe.cfg":
		content => template('nagios/nrpe/nrpe.cfg'),
		owner => root, group => root, mode => 644;
	}
	
	# default commands
	file { "$nagios_nrpe_cfgdir/nrpe.d/nrpe_commands.cfg":
		source => [ "puppet:///site-nagios/nrpe/nrpe_commands.cfg",
			    "puppet:///nagios/nrpe/nrpe_commands.cfg" ],
		owner => root, group => root, mode => 644;
	}

	#file { "/usr/local/lib/nagios":
	#  source => "puppet://puppet/nagios-client/plugins",
	#    recurse => "true"
	#    }

	service { "nagios-nrpe-server":
    		ensure    => running,
    		enable    => true,
    		pattern   => "nrpe",
    		subscribe => [  File["$nagios_nrpe_cfgdir/nrpe.cfg"],  
				File["$nagios_nrpe_cfgdir/nrpe.d/nrpe_commands.cfg"] ]
	}

}

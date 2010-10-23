class nagios::pnp4nagios {
    include nagios::defaults::pnp4nagios

    package { [php5, php5-gd, rrdcollect, rrdtool, librrdp-perl, librrds-perl ]:
              ensure => installed }


    # unfortunatly there is still no way to use nagios_host and nagios_service definition
    # to create templates
    # http://projects.puppetlabs.com/issues/1180
    # so we need to copy a file here.
 
    file { 'pnp4nagios-templates.cfg':
         path => "$nagios::nagios_cfgdir/conf.d/pnp4nagios-templates.cfg",
         source => [ "puppet:///modules/site-nagios/pnp4nagios/pnp4nagios-templates.cfg",
                     "puppet:///modules/nagios/pnp4nagios/pnp4nagios-templates.cfg"    ]
    }
    
    file { 'apache.conf':
        path => "/etc/pnp4nagios/apache.conf",
        source => [ "puppet:///modules/site-nagios/pnp4nagios/apache.conf",
    		        "puppet:///modules/nagios/pnp4nagios/apache.conf"    	
    	      ],
	notify => Service['apache'],
    }


}

class dw::dwcron {

cron { 'restart_dlts' :
        command => "/opt/dw/dw-etc/dw_restart-cron.sh",
	user => 'dw',
	minute => "*/15",
	require => [User['dw']],
	ensure => 'present',
	}

}

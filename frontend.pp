class dw::frontend {
	 
	 $application='dw'
	 $appgroup='dw'
	 #$complex='dw'
	 $sslkey= hiera('sslkey','wildcard.dw.info.key')
	 $sslcert= hiera('sslcrt','wildcard.dw.info.crt')
	 #$sslchain= hiera('sslchain','CAchain.crt')
	 $servername= hiera('servername')

	 $eth1 = $ipaddress_eth1
	 $eth0 = $ipaddress_eth0
	    

	 package { 'httpd' :
	   ensure => present,
	 }

	 package { 'mod_ssl' :
	   ensure => present,
	   require => Package['httpd'],
	 }
 
	 package { 'mod_perl' :
	   ensure => present,
	   require => Package['httpd'],
	 }
   #confiuration file for apache
	 file { '/etc/httpd/conf/httpd.conf' :
	   ensure => 'file',
	   owner => 'root',
	   group => 'root',
	   mode => "0644",
	   content => template('dw/frontend/httpd.erb'),
	   require => Package['httpd'],
	 }

   #log file for apache
   file { '/opt/log' :
	 ensure => 'directory',
	 owner => 'dw',
	 group => 'dw',
	 mode => "0755",
	 require => [User['dw']],
	    }

   file { '/opt/log/dw' :
	ensure => 'directory',
	owner => 'dw',
	group => 'dw',
	mode => "0755",
	require => [User['dw']],
	}


    #configuration directory for ssl
	 file { '/etc/pki/tls/private' :
	   ensure => 'directory',
	   owner => 'root',
	   group => 'root',
	   mode => "0700",
	   require => Package['mod_ssl'],
	 }
	 file { '/etc/pki/tls/certs' :
	   ensure => 'directory',
	   owner => 'root',
	   group => 'root',
	   mode => "0700",
	   require => Package['mod_ssl'],
	 }
#the ssl key for apache
	 file { "/etc/pki/tls/private/${sslkey}" :
	   ensure => 'file',
	   owner => 'root',
	   group => 'root',
	   mode => "0755",
	   source => "puppet:///modules/dw/ssl/${sslkey}",
	   require => Package['mod_ssl'],
	 }
#the ssl certificate for apache
 file { "/etc/pki/tls/certs/${sslcert}" :
           ensure => 'file',
           owner => 'root',
           group => 'root',
	   mode => "0755",
	   source => "puppet:///modules/dw/ssl/${sslcert}",
	   require => Package['mod_ssl'],
	 }
# Disable default conf for ssl.conf if not SSL will not work
	file { '/etc/httpd/conf.d/ssl.conf' :
             ensure => 'file',
             owner => 'root',
             group => 'root',
             mode => "0644",
             content => template('dw/frontend/ssl.erb'),
             require => Package['mod_ssl'],
           }

		 
}

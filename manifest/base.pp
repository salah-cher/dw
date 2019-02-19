class dw::base {

  $appgroup = 'dw'
  $application = 'dw'

  $pg_ver = hiera('pg_ver')
  $java_home ='/usr/java/jre1.8.0_101'
  
  $pg_package_list = [
    "postgresql${pg_ver}.corp",
    "postgresql${pg_ver}.corp-devel",
    "postgresql${pg_ver}.corp-libs",
    ]

#user prod
  user { 'prod':
    ensure     => present,
    uid        => '10000',
    home       => '/opt/prod',
    gid        => 'prod',
    managehome => true,
    #require    => File['/opt/home'],
  }
  
  group { 'prod':
    gid => '10000'
  }
  
#user dw , home dir and bash_profile
    user { 'dw' :
      	ensure => 'present',
        managehome => true,
	uid => '303',
	gid => 'dw',
        home => "/opt/dw",
	       }

  group { 'dw':
    gid => '303'
  }

  file { '/opt/dw' :
	ensure => 'directory',
	owner => 'dw',
	group => 'dw',
	mode => "0755",
	require => [User['dw']],
	}


  file { '/opt/dw/.bash_profile' :
        path    => "/opt/dw/.bash_profile",
        content => template('dw/bash_profile.erb'),
        owner => 'dw',
        group => 'dw',
        mode  => "0744",
        require => [User['dw'],File['/opt/dw/']]
        }
    #pgpass for DB connection 
        $dw_pgpass = hiera('dw_pgpass')
        
    file { '/opt/dw/.pgpass' :
        content => template('dw/pgpass.erb'),
        owner => 'dw',
        group => 'dw',
        mode => "0600",
        require => [User['dw'],File['/opt/dw/']]
        }

     exec { 'dw ownership' :
         command => 'chown -R dw:dw /opt/dw',
         path => '/usr/bin:/bin:/usr/local/bin',
         require => [User['dw'],File['/opt/dw/']]
           }


        #  yumrepo { 'postgresql-corp-com':
        #enabled => 1,
        #descr  => 'Local corp repo for postgres packages',   
        #baseurl => "http://repo.tor.corp-int.info/projectrepos/postgresql-corp/RedHat-7.2/",
        #baseurl => "http://com-hub.tor.corp-int.info/comfiles/packages/postgresql963.corp/9.6.3/1.el7/x86_64/",
        #baseurl => "http://repo.tor.corp-int.info/corp_projects/dist-el7/x86_64/os",
        #gpgcheck => 0,
        #}

 package { $pg_package_list :
        ensure => present,
        require => Yumrepo['com']
   }

  yumrepo { 'com':
	enabled => 1,
	descr  => 'Local corp repo for perl packages',    
	baseurl => "http://repo.tor.corp-int.info/corp_projects/dist-el7/x86_64/os/",
	gpgcheck => 0,
    }

  
  $packagelist_common = [
        "perl",
        "perl-Log-Log4perl",
        "perl-Date-Calc",
        "perl-TimeDate",
        "perl-DBD-Pg",
        "perl-Config-General",
        "perl-Error",
        "perl-HTML-Mason",
        "perl-DBI",
        "perl-MIME-Lite",
        "perl-MIME-Types",
        "perl-Devel-StackTrace",
        "perl-CGI",
        "perl-Math-Round",
        "perl-Number-Format",
        "perl-Time-HiRes",
   ]

package { $packagelist_common :
     ensure => present,
     require => Yumrepo['com']
   }  

# install yum repo for java and then install the package java 
 yumrepo { 'java_8':
	descr  => 'Local corp repo for java packages',    	
	baseurl => "http://repo.tor.corp-int.info/mrepo/RedHat-7.2-x86_64/RPMS.java-1.8/",
	enabled => 1,
	gpgcheck => 0,
	}

 package { 'jre1.8.0_101':
        ensure => 'latest',
	require => [Yumrepo['java_8']],
	install_options => ["--nogpgcheck"],
        }


}

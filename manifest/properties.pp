class dw::properties {

  $application = 'dw'
  $appgroup = 'dw'
  $group = 'dw'
  $etc_directory = "/opt/${application}/${application}-etc"
  $etc_build_directory = "/opt/${application}/${application}/etc"

  # Requires $application
  $application_properties = "${application}_properties"
  $common_properties = hiera_array(common_conf, ['unset'])
  $web_properties = hiera_array(web_conf, ['unset'])
  $source_db_cfg = hiera_array('source_db_conf', ['unset'])
  $app_db_cfg = hiera_array('app_db_conf', ['unset'])

  # Common app db props 
  $app_db_conf_common = hiera_array('app_db_conf_common', ['unset'])
  $app_db_conf_common_creds = hiera('app_db_pass_common_creds', 'unset')
  $db_users = hiera_array('db_users', ['unset'])
  $db_creds = hiera('db_creds', ['unset'])




  # dw properties 
  $dw_properties = hiera_array(dw_prop, ['unset'])
  $dw_db_password = hiera('dw_dlt_passwd', 'unset')
  $dw_db_user = hiera('dw_dlt_conf_user', 'unset')
  $dw_db_host = hiera ('dw_db_conf_host', 'unset')
  $dw_db_port = hiera ('dw_db_conf_port', 'unset')
  $dw_db_name = hiera ('dw_db_conf_name', 'unset')
    

# dw -pre-env 
  $dw_pre_env = hiera_array(dw_pre_envir, ['unset'])

  File { owner => 'dw', group => 'dw' }

# Web.cfg and common.cfg for dw-etc  
  file { "${etc_directory}/common.cfg":
    ensure => present,
    mode => '640',
    content => template("dw/common.cfg.erb"),
    }

  file { "${etc_directory}/web.cfg":
    ensure => present,
    mode => '640',
    content => template("dw/web.cfg.erb"),
    }
# Web.cfg and common.cfg for dw/etc

 file { "${etc_build_directory}/common.cfg":
      ensure => 'link',
      target => '/opt/dw/dw-etc/common.cfg',
      }

 file { "${etc_build_directory}/web.cfg":
      ensure => 'link',
      target => '/opt/dw/dw-etc/web.cfg',
      }

#dw-pre-env.sh
file { "${etc_directory}/dw-pre-env.sh":
    ensure => present,
    mode => '640',
    content => template("dw/dw-pre-env.sh.erb"),
     }
#dw.properties
file { "${etc_directory}/dw.properties":
    ensure => present,
    mode => '640',
    content => template("dw/dw.properties.erb"),
     }



}

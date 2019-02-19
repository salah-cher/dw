class dw::directories {

  $group = hiera('application_group', 'dw')
  $application = 'dw'
  $appgroup = 'dw'

  $etc_directory = "${application}-etc"
  $util_directory = "${application}-util"
  $builds_directory = hiera('downstream_builds_directory')
  $base_directory = hiera("${application}_base", "/opt/${application}")
  #$users    = hiera_hash("${application}_users",{})
  #$username = $users[$application]['username']
  $username = 'dw'
  #$uid      = $users[$application]['uid']

  ## Resource defaults
  File {
    ensure => present,
    owner  => $username,
    group  => $group,
    mode   => '0640',
  }


 file { "${base_directory}/${builds_directory}":
    ensure => directory,
    mode   => '0750',
  }

file { "${base_directory}/${etc_directory}":
    ensure  => directory,
    mode    => '0750',
    recurse => true,
    source  => "puppet:///modules/dw/${application}-etc/",
    }
  
 
 }

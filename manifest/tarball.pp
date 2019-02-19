class dw::tarball {

  $application = 'dw'
  $appgroup = 'dw'
  $application_packages = hiera_hash('downstream_application_packages')
  $builds_directory     = hiera('downstream_builds_directory')
  $group = hiera('application_group', 'dw')
  $appdir               = undef
  #$etc_directory = "${base_dirctory}/${application}/${application}-etc"
  $etc_directory = "${base_directory}/${application}/${application}/etc"

  notice("application is ${application}")
  notice("etc_directory is ${etc_directory}")

  # Requires $application
  $package = $application_packages[$application]
  # Requires $application
  $base_directory = hiera("${application}_base", '/opt')
  if ! $appdir {
    $appdir_real = "${base_directory}/${application}"
  } else {
    $appdir_real = "${base_directory}/${appdir}"
  }
  #$etc_directory = 
  #$etc_directory = "${base_directory}/${application}/${application}-etc"
  #$etc_directory = "${base_directory}/${application}/${application}/etc"
  notice("etc_directory is ${etc_directory}")
  # Requires $complex, $application
  # Requires $application
  $target = hiera("${application}_target_directory")
  # Requires $::system, $application
  $versions = hiera_hash('downstream_versions')
  $version = $versions[$application] #Version of package for $application

  # These checks are to avoid nasty hiera errors when undef
  if ! $package { fail("dw::Tarball[${name}]: Error, missing value for \$package") }
  if ! $version { fail("dw::Tarball[${name}]: Error, missing value for \$version") }
  # Requires $package, $version, $deploy_method
  $deploy_methods = hiera_hash('downstream_deploy_methods')
  $deploy_method = $deploy_methods[$application]
  $symlink = "${package}-${version}"
  $tarball_urls = hiera_hash('downstream_tarball_urls')
  $tarball_url = $tarball_urls[$deploy_method]

  # Download the build
  exec { "Download - $application - $version":
    command   => "wget ${tarball_url} -O ${package}-${version}.tar.gz",
    cwd       => "${appdir_real}/${builds_directory}",
    #creates   => "${appdir_real}/${builds_directory}/${package}-${version}.tar.gz",
    unless     =>  "/usr/bin/test -s ${appdir_real}/${builds_directory}/${package}-${version}.tar.gz",
    user      => 'dw',
    group     => $group,
    path      => "/usr/bin:/bin:/usr/local/bin",
    require   => File["${appdir_real}/${builds_directory}"],
    logoutput => 'on_failure',
  }

  # Extract the build
  # This is only executed if the Download section above is executed
  exec { "Extract Build - $application - $version":
    path        => "/usr/local/bin:/bin:/usr/bin",
    command     => "gunzip -c ${package}-${version}.tar.gz | tar xf -",
    user        => 'dw',
    group       => $group,
    cwd         => "${appdir_real}/${builds_directory}",
    subscribe   => Exec["Download - $application - $version"],
    refreshonly => true,
    logoutput   => 'on_failure',
    notify      => File["${appdir_real}/${target}"],
  }
  file { "$application - symlink":
    ensure  => link,
    path    => "${appdir_real}/${target}",
    target  => "${builds_directory}/${symlink}",
  }

 

  }

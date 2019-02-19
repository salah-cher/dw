class dw::lrms {
  $appgroup = 'dw'
  $application = 'dw'
  $application_packages = hiera_hash('downstream_application_packages')
  $builds_directory     = hiera('downstream_builds_directory','src')
  $group = hiera('application_group', 'dw')
  $appdir               = undef

  $sub_application = "${application}_lrms"
  notice("application is ${application}")

  $package = $application_packages[$sub_application]
  $base_directory = hiera("${application}_base", '/opt')
  if ! $appdir {
    $appdir_real = "${base_directory}/${application}"
  } else {
    $appdir_real = "${base_directory}/${appdir}"
  }
  # Requires $application
  $target = hiera("${application}_lrms_target_directory")
  # Requires $::system, $application
  $versions = hiera_hash('downstream_versions')
  $version = $versions[$sub_application] #Version of package for $application

  # These checks are to avoid nasty hiera errors when undef
  if ! $package { fail("dw::Deploy::Tarball[${name}]: Error, missing value for \$package") }
  if ! $version { fail("dw::Deploy::Tarball[${name}]: Error, missing value for \$version") }
  # Requires $package, $version, $deploy_method
  $deploy_methods = hiera_hash('downstream_deploy_methods')
  $deploy_method = $deploy_methods[$sub_application]
  $symlink = "${package}-${version}"
  $tarball_urls = hiera_hash('downstream_tarball_urls')
  $tarball_url = $tarball_urls[$deploy_method]

/*  file { "/opt/dw":
    ensure  => directory,
    owner   => 'dw',
    mode  => '0770',
  }

  */
  # Download the build
  exec { "Download - $application - lrms - $version":
    command   => "wget ${tarball_url} -O ${package}-${version}.tar.gz",
    cwd       => "${base_directory}/dw",
    creates   => "${base_directory}/dw/${package}-${version}.tar.gz",
    user      => 'dw',
    group     => 'dw',
    path      => "/usr/bin:/bin:/usr/local/bin",
    require   => File["${base_directory}/dw"],
    logoutput => 'on_failure',
  }

  # Extract the build
  # This is only executed if the Download section above is executed
  exec { "Extract Build - $application - lrms - $version":
    path        => "/usr/local/bin:/bin:/usr/bin",
    command     => "gunzip -c ${package}-${version}.tar.gz | tar xf -",
    user        => 'dw',
    group       => 'dw',
    cwd         => "${base_directory}/dw",
    subscribe   => Exec["Download - $application - lrms - $version"],
    refreshonly => true,
    logoutput   => 'on_failure',
    notify      => File["${appdir_real}/${target}"],
  }
  file { "$application - lrms - symlink":
    ensure  => link,
    path    => "${appdir_real}/${target}",
    target  => "/opt/dw/${symlink}",
  }
}

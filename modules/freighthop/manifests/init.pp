class freighthop(
  $databases,
  $database_users,
  $packages        = ['git-core'],
  $ruby_version    = $freighthop::params::ruby_version,
  $app_name        = $freighthop::params::app_name,
  $app_root        = $freighthop::params::app_root,
  $web_root        = $freighthop::params::web_root,
  $socket_dir      = $freighthop::params::socket_dir,
  $socket_path     = $freighthop::params::socket_path,
  $server_name     = $freighthop::params::server_name,
  $ssl_cert_path   = $freighthop::params::ssl_cert_path,
  $ssl_key_path    = $freighthop::params::ssl_key_path,
) inherits freighthop::params {
  file { $socket_dir:
    ensure => directory,
    owner  => 'vagrant',
    group  => 'vagrant',
    mode   => '0755'
  }
  class { 'freighthop::pkgs':
    packages => $packages,
  }
  class { 'freighthop::rbenv':
    ruby_version => $ruby_version
  }
  class { 'freighthop::nginx':
    upstream_socket_path => $socket_path,
    server_name          => $server_name,
    web_root             => $web_root,
    ssl_cert_path        => $ssl_cert_path,
    ssl_key_path         => $ssl_key_path,
  }
  class { 'freighthop::postgres':
    databases      => $databases,
    database_users => $database_users,
  }
  class { 'freighthop::bundler':
    ruby_version => $ruby_version,
    app_root     => $app_root,
  }
  class { 'freighthop::puma':
    app_root    => $app_root,
    socket_path => $socket_path,
  }

  File[$socket_dir] ->
    Class['freighthop::pkgs'] ->
    Class['freighthop::rbenv'] ->
    Class['freighthop::nginx'] ->
    Class['freighthop::postgres'] ->
    Class['freighthop::bundler'] ->
    Class['freighthop::puma']

}

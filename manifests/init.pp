class {'dashing':
    dashing_package_name => 'dashing',
    package_status       => installed,
    dashing_conf         => '/etc/dashing.conf',
    dashing_default      => '/etc/default/dashing',
    dashing_binary       => '/usr/local/bin/dashing',
    dashing_basepath     => '/usr/share/dashing',
    run_user             => 'root',
    run_group            => 'root',
    service_name         => 'dashing',
    enable               => true,
}
dashing::instance {'ceph':
  targz            => 'puppet:///modules/dashing/dashboard',
  dashing_port     => '3030',
  dashing_dir      => "$dashing::dashing_basepath/$name",
  strip_parent_dir => true,
}
exec { "bundle install":
    command => "bundle install",
    path    => "/usr/bin/:/bin/",
    cwd => "/usr/share/dashing/main",
    notify => Service["dashing"]
}
class { 'nodejs':
  version => 'stable',
}
file { "/opt/aws-dashing/":
	ensure  => present,
    mode   => 755,
    owner  => root,
    group  => root,
    recurse => true,
    source => "puppet:///modules/nodejs/aws-dashing/"
}
file { '/etc/init.d/nodedashing':
   ensure => 'present',
   owner  => 'root',
   group  => 'root',
   mode   => '0755',
   source => "puppet:///modules/nodejs/aws-dashing/nodedashing",
    notify    => Service['nodedashing'], 

}
service { 'nodedashing' :
      ensure    => running,
      hasstatus => false
}

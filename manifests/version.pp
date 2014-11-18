define solr::version (
  $war,
  $ensure   = present,
  $example  = undef,
  $lib      = undef,
) {
  require solr

  file { "${::solr::dest_dir}/${name}/solr.war" :
    ensure => $ensure,
    source => $war,
    owner  => $::solr::user,
    group  => $::solr::group,
    mode   => 0644,
    notify => $::solr::notify,
  }
  file { "${::solr::dest_dir}/${name}/example" :
    ensure   => $ensure ? {
      present => directory,
      default => absent,
    },
    source   => $config,
    recurse => true,
    owner    => $::solr::user,
    group    => $::solr::group,
    mode     => 0644,
  }
  file { "${::solr::dest_dir}/${name}/lib" :
    ensure   => $ensure ? {
      present => directory,
      default => absent,
    },
    source   => $lib,
    recurse => true,
    owner    => $::solr::user,
    group    => $::solr::group,
    mode     => 0644,
    notify   => $::solr::notify,
  }
}

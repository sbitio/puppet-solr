class solr (
  $user               = $::solr::params::user,
  $group              = $::solr::params::group,
  $notify             = $::solr::params::notify,
  $ensure             = present,
  $available_versions = {},
  $dest_dir           = '/opt/solr'
) inherits solr::params {
  file { $dest_dir :
    ensure => $ensure ? {
      present => directory,
      default => absent,
    },
    purge  => true,
    owner  => $::solr::user,
    group  => $::solr::group,
    mode   => '0644',
  }
}

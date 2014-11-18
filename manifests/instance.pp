define solr::instance (
  $directory,
  $version,
  $ensure             = present,
  $mange_version      = true,
  $initialize         = true,
  $app_server_connect = true,
  $unmanaged_docbase  = undef,
  $unmanaged_liddir   = undef,
) {
  require solr
  #TODO# Add stdlib dependency
  if $manage_version {
    if is_hash($version) {
      #TODO# validate hash
      $version_name = keys($version)
      ensure_resource(::solr::version, $version_name, $version[$version_name])
    }
    else {
      $version_name = $version
      ensure_resource(::solr::available_version, $version)
    }
    if $initialize {
      case $ensure {
        present : {
          #TODO# find a prettier solution
          $source_conf = "${::solr::dest_dir}/${name}/example"
          exec { "copy-solr-example-to-${directory}":
            cmd     => "cp -ar ${source_conf} ${directory}",
            creates => $directory,
          }
        }
        absent  : {
          file { $directory :
            ensure => absent,
          }
        }
      }
    }
    $docbase = "${::solr::dest_dir}/${name}/solr.war"
    $libdir  = "${::solr::dest_dir}/${name}/lib"
  }
  else {
    #TODO# validate
    $docbase      = $unmanaged_docbase
    $libdir       = $unmanaged_libdir
  }
  if $app_server_connect {
    case $::solr::application_server_class {
      tomcat : {
        #TODO# make conector
        ::tomcat::context { $name:
          content => template('solr/tomcat.erb'),
        }
      }
      default : {
        fail("Unsupported aplication server class: ${::solr::application_server_class}")
      }
    }
  }
}

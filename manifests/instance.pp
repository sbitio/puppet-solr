define solr::instance (
  $directory,
  $version,
  $ensure     = present,
  $initialize = true,
) {
  require solr


  case $ensure {
    present : {
      ensure_resource(solr::version, $version)
      if $initialize {
        #TODO# find a prettier solution
        $source_conf = "${::solr::dest_dir}/${version}/example"
        exec { "copy-solr-example-to-${directory}":
          command => "cp -ar ${source_conf} ${directory}",
          creates => $directory,
        }
      }
    }
    absent  : {
      file { $directory :
        ensure => absent,
      }
    }
  }

  case $::solr::application_server_class {
    tomcat : {
      #TODO# find a prettier solution
      $docbase = "${::solr::dest_dir}/${version}/solr.war"
      $lib     = "${::solr::dest_dir}/${version}/lib"
      ::tomcat::context { $name:
        ensure  => $ensure,
        content => template('solr/tomcat.erb'),
      }
    }
    default : {}
  }

}

class solr::params (
  $application_server_class = 'tomcat',
) {

  case $application_server_class {
    tomcat : {
      require ::tomcat
      $user   = $::tomcat::user
      $group  = $::tomcat::group
      $notify = Class["::tomcat::service"]    
    }
    default : {
      warning("Unsupported application_server_class '${application_server_class}'")
    }
  }
}

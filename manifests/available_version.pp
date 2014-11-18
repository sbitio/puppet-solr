define solr::available_version () {
  require solr
  ensure_resource(
    ::solr::version,
    $name,
    $::solr::available_versions[$name]
  )
}

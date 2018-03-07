class clipbucket {
  class {'::clipbucket::apache':} ~>
  class {'::clipbucket::install':}
  # require clipbucket::config
}
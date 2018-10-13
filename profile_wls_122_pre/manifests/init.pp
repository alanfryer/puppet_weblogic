class profile_wls_122_pre {

  unless $::kernel in ['Linux'] {
    fail('Unrecognized operating system, use this class on a Linux or Solaris host')
  }
  notify {"Finished $stage":}
  group { 'oinstall' :
    ensure => present,
  }

  user { 'oracle' :
    ensure     => present,
    uid        => 500,
    gid        => 'oinstall',
    shell      => '/bin/bash',
    home       => '/home/oracle',
    comment    => 'created by puppet for WebLogic installation',
    require    => Group['oinstall'],
    managehome => true,
  }
  notify {'Finished adding users and groups' :}
}



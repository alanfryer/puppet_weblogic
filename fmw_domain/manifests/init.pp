#
# fmw_domain
#
# Copyright 2015 Oracle. All Rights Reserved
#
class fmw_domain(
  $version                       = lookup('fmw_domain::version'),
  $java_home_dir                 = undef,
  $middleware_home_dir           = lookup('fmw_domain::middleware_home_dir'),
  $weblogic_home_dir             = undef,
  $os_user                       = lookup('fmw_domain::os_user'),
  $os_group                      = lookup('fmw_domain::os_group'),
  $user_home_dir                 = lookup('fmw_domain::user_home_dir'),
  $tmp_dir                       = lookup('fmw_domain::tmp_dir'),
  $nodemanager_listen_address    = undef,
  $nodemanager_port              = lookup('fmw_domain::nodemanager_port'),
  $domains_dir                   = lookup('fmw_domain::domains_dir'),
  $apps_dir                      = lookup('fmw_domain::apps_dir'),
  $domain_name                   = undef,
  $machine_name                  = undef,
  $weblogic_user                 = lookup('fmw_domain::weblogic_user'),
  $weblogic_password             = undef,
  $adminserver_name              = lookup('fmw_domain::adminserver_name'),
  $adminserver_listen_address    = undef,
  $adminserver_listen_port       = lookup('fmw_domain::adminserver_listen_port'),
  $restricted                    = lookup('fmw_domain::restricted'),
  $adminserver_startup_arguments = lookup('fmw_domain::adminserver_startup_arguments'),

){}

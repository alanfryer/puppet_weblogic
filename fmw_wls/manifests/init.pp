#
# fmw_wls
#
# Copyright 2015 Oracle. All Rights Reserved
#
class fmw_wls(
  $version             = lookup('fmw_wls::version'), 
  $middleware_home_dir = lookup('fmw_wls::middleware_home_dir'),
  $ora_inventory_dir   = lookup('fmw_wls::ora_inventory_dir'),
  $orainst_dir         = lookup('fmw_wls::orainst_dir'),
  $os_user             = lookup('fmw_wls::os_user'),
  $os_user_uid         = lookup('fmw_wls::os_user_uid'),
  $os_group            = lookup('fmw_wls::os_group'),
  $os_shell            = lookup('fmw_wls::os_shell'),
  $user_home_dir       = lookup('fmw_wls::user_home_dir'),
  $tmp_dir             = lookup('fmw_wls::tmp_dir'),
) #inherits fmw_wls::params {
{}
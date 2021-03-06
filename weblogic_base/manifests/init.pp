class weblogic_base {
   $version                        = lookup('weblogic_base::wls_version', String)
   $java_home_dir                  = lookup('weblogic_base::java_home_dir', String)
   $source_file                    = lookup('weblogic_base::wls_source_file', String)
   $middleware_home_dir            = lookup('weblogic_base::wls_middleware_home_dir', String)
   $domain_name                    = lookup('weblogic_base::domain_name', String)
   $machine_name                   = lookup('weblogic_base::machine_name', String)
   $weblogic_user                  = lookup('weblogic_base::weblogic_user', String)
   $weblogic_password              = lookup('weblogic_base::weblogic_password', String)
   $adminserver_name               = lookup('weblogic_base::adminserver_name', String)
   $adminserver_listen_address     = $hostname
   $adminserver_listen_port        = lookup('weblogic_base::adminserver_listen_port', Integer)
   $adminserver_startup_arguments  = lookup('weblogic_base::adminserver_startup_arguments', String)
   $nodemanager_listen_address     = $hostname
   $nodemanager_port               = lookup('weblogic_base::nodemanager_port', Integer)

   class { 'fmw_wls':
      middleware_home_dir => $middleware_home_dir,
   }

   class{'fmw_wls::install':
      java_home_dir => $java_home_dir,
      source_file   => $source_file,
   }
   
   class { 'fmw_domain': 
      version                       => $wls_version,                                          
      java_home_dir                 => $java_home_dir,
      middleware_home_dir           => $middleware_home_dir,                            
      weblogic_home_dir             => "${middleware_home_dir}/wlserver",
      domains_dir                   => "${middleware_home_dir}/domains",     
      apps_dir                      => "${middleware_home_dir}/apps", 
      domain_name                   => $domain_name,
      machine_name                  => $machine_name,
      weblogic_user                 => $weblogic_user,                                         
      weblogic_password             => $weblogic_password,
      adminserver_name              => $adminserver_name,                                      
      adminserver_listen_address    => $adminserver_listen_address,
      adminserver_listen_port       => $adminserver_listen_port,                                                
      nodemanager_listen_address    => $nodemanager_listen_address,
      nodemanager_port              => $nodemanager_port,                                               
      adminserver_startup_arguments => $adminserver_startup_arguments,
   }

   class{ 'fmw_domain::domain': }
  
   class{ 'fmw_domain::nodemanager': } 

   class{ 'fmw_domain::adminserver': }

}


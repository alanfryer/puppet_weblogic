#
# fmw_domain::nodemanager
#
# Copyright 2015 Oracle. All Rights Reserved
#
class fmw_domain::nodemanager()
{
  require fmw_domain::domain

  if $fmw_domain::version == '10.3.6' {
    $nodemanager_home_dir  = "${fmw_domain::weblogic_home_dir}/common/nodemanager"
    $bin_dir               = "${fmw_domain::weblogic_home_dir}/server/bin"
    $nodemanager_template  = 'nodemanager.properties_11g'
    $nodemanager_check     = $fmw_domain::weblogic_home_dir
    $script_name           = 'nodemanager_11g'
  } else {
    $nodemanager_home_dir  = "${fmw_domain::domains_dir}/${fmw_domain::domain_name}/nodemanager"
    $bin_dir               = "${fmw_domain::domains_dir}/${fmw_domain::domain_name}/bin"
    $nodemanager_template  = 'nodemanager.properties_12c'
    $nodemanager_check     = "${fmw_domain::domains_dir}/${fmw_domain::domain_name}"
    $script_name           = "nodemanager_${fmw_domain::domain_name}"
  }

  $nodemanager_log_dir        = "${nodemanager_home_dir}/nodemanager.log"
  $nodemanager_lock_file       = "${nodemanager_home_dir}/nodemanager.log.lck"
  $nodemanager_secure_listener = true
  $nodemanager_address         = $fmw_domain::nodemanager_listen_address
  $nodemanager_port            = $fmw_domain::nodemanager_port
  $platform_family             = $::osfamily
  $version                     = $fmw_domain::version


  $java_home_dir        = $fmw_domain::java_home_dir
  $domain_dir           = "${fmw_domain::domains_dir}/${fmw_domain::domain_name}"

  file { "${nodemanager_home_dir}/nodemanager.properties":
    ensure  => present,
    content => template("fmw_domain/nodemanager/${nodemanager_template}"),
    mode    => '0755',
    owner   => $fmw_domain::os_user,
    group   => $fmw_domain::os_group,
  }


  if $::kernel in ['Linux'] {
    $netstat_cmd = 'netstat -an | grep LISTEN'
    $netstat_column = 3

    $nodemanager_bin_path = $bin_dir
    $os_user              = $fmw_domain::os_user

    $jsse_enabled = false
    $trust_env = ''
    if $jsse_enabled == true {
      $env = "JAVA_OPTIONS=-Dweblogic.ssl.JSSEEnabled=true -Dweblogic.security.SSL.enableJSSE=true ${trust_env} ${extra_arguments}"
    } else {
       $env = "JAVA_OPTIONS=-Dweblogic.ssl.JSSEEnabled=false -Dweblogic.security.SSL.enableJSSE=false ${trust_env} ${extra_arguments}"
    }

    if (  $fmw_domain::version == '10.3.6' ){
      $checkCommand = '/bin/ps -eo pid,cmd | grep -v grep | /bin/grep \'weblogic.NodeManager\''
    } else {
       $checkCommand = "/bin/ps -eo pid,cmd | grep -v grep | /bin/grep 'weblogic.NodeManager' | /bin/grep ${fmw_domain::domain_name}"  
    }

    $startCommand      = "nohup ${bin_dir}/startNodeManager.sh  > ${nodemanager_home_dir}/nodemanager_nohup.log 2>&1 &"
    $restartCommand    = "kill $(${checkCommand} | awk '{print \$1}'); sleep 1; ${startCommand}"
    $exec_path = "${java_home_dir}}/bin/java:/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin"

    exec { "startNodemanager":
      command     => $startCommand,
      environment => [ $env, "JAVA_HOME=${java_home_dir}", 'JAVA_VENDOR=Oracle' ],
      unless      => $checkCommand,
      path        => $exec_path,
      user        => $fmw_domain::os_user,
      group       => $fmw_domain::os_group,
      cwd         => $nodemanager_home_dir,
    }

    exec {"restart NodeManager":
      command     => $restartCommand,
      environment => [ $env, "JAVA_HOME=${java_home_dir}", 'JAVA_VENDOR=Oracle' ],
      onlyif      => $checkCommand,
      path        => $exec_path,
      user        => $fmw_domain::os_user,
      group       => $fmw_domain::os_group,
      cwd         => $nodemanager_home_dir,
      refreshonly => true,
      #subscribe   => File[$propertiesFileTitle],
    }

  } elsif $::kernel in ['SunOS'] {
    $netstat_cmd = 'netstat -an | grep LISTEN'
    $netstat_column = 0
  }

#  fmw_domain_nodemanager_status{$script_name:
#    ensure           => 'running',
#    command          => $netstat_cmd,
#    column           => $netstat_column,
#    nodemanager_port => $fmw_domain::nodemanager_port,
#  }

}
#
# fmw_domain::nodemanager
#
# Copyright 2015 Oracle. All Rights Reserved
#
class fmw_domain::certificates()
{
  


  $java_home_dir        = $fmw_domain::java_home_dir
  $domain_dir           = "${fmw_domain::domains_dir}/${fmw_domain::domain_name}"

  file { "${nodemanager_home_dir}/nodemanager.properties":
    ensure  => present,
    content => template("fmw_domain/nodemanager/${nodemanager_template}"),
    mode    => '0755',
    owner   => $fmw_domain::os_user,
    group   => $fmw_domain::os_group,
  }


  $startCommand      = "nohup ${bin_dir}/startNodeManager.sh  > ${nodemanager_home_dir}/nodemanager_nohup.log 2>&1 &"
  $restartCommand    = "kill $(${checkCommand} | awk '{print \$1}'); sleep 1; ${startCommand}"
  $exec_path = "${java_home_dir}}/bin/java:/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin"

  exec { "create_self_signed_sslcert":
    command     => $startCommand,
    environment => [ $env, "JAVA_HOME=${java_home_dir}", 'JAVA_VENDOR=Oracle' ],
    path        => $exec_path,
    user        => $fmw_domain::os_user,
    group       => $fmw_domain::os_group,
    cwd         => "${domain_dir}/security",
  }

exec {'create_self_signed_sslcert':
  command => "openssl req -newkey rsa:2048 -nodes -keyout ${::fqdn}.key  -x509 -days 365 -out ${::fqdn}.crt -subj '/CN=${::fqdn}'"
  cwd     => $certdir,
  creates => [ "${certdir}/${::fqdn}.key", "${certdir}/${::fqdn}.crt", ],
  path    => ["/usr/bin", "/usr/sbin"]
}
 
}
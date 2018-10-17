MODULE_PATH=/home/afryer/puppet/puppet_weblogic:/etc/puppetlabs/code/modules
puppet apply --debug --modulepath $MODULE_PATH --environment dev /home/afryer/puppet/puppet_weblogic/role_wls_122/manifests/site.pp

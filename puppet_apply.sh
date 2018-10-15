MODULE_PATH=/home/afryer/puppet/puppet_weblogic
puppet apply --debug --modulepath $MODULE_PATH --environment dev $MODULE_PATH/role_wls_122/manifests/site.pp

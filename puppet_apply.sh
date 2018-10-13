MODULE_PATH=/home/afryer/puppet/modules
puppet apply --debug --modulepath $MODULE_PATH --environment production $MODULE_PATH/role_wls_122/manifests/site.pp

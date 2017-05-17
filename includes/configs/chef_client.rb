log_level        :auto
log_location     "/tmp/chef_client.log"
chef_server_url  'https://megatron.ohkeenan.com/organizations/nimboweb'
validation_client_name 'chef-nimboweb-validator'
validation_key '/etc/chef/validator.pem'
client_key '/etc/chef/client.pem'
node_name 'ohkeenan'

# Remove the repository
yum_repository "mongodb-org-#{node['mongodb']['version']}"" do
  description "MongoDB Repository"
  baseurl "https://repo.mongodb.org/yum/redhat/$releasever/mongodb-org/#{node['mongodb']['version']}/x86_64/"
  gpgkey "https://www.mongodb.org/static/pgp/server-#{node['mongodb']['version']}.asc"
  action :delete
end

# Stop the service
service 'mongod' do
  action :stop
end

# Remove the package
package 'mongodb-org' do
  action :remove
end

# Clean up files
script 'clean_files' do
  interpreter "bash"
  code <<-EOH
    sudo rm -r /var/log/mongodb
    sudo rm -r /var/lib/mongo
  EOH
  only_if { ::File.exist?('/var/log/mongodb') || ::File.exist?('/var/lib/mongo') }
end

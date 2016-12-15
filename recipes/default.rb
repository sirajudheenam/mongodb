#
# Cookbook Name:: mongodb
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

case node[:platform]
  when 'redhat','centos'
    if node['platform']['version'] == "6" then
        %w(cyrus-sasl cyrus-sasl-plain cyrus-sasl-gssapi krb5-libs net-snmp openssl libcurl).each do |pkg|
          package pkg
        end
    elsif node['platform']['version'] == "7" then
        %w(cyrus-sasl cyrus-sasl-plain cyrus-sasl-gssapi krb5-libs lm_sensors-libs net-snmp-agent-libs net-snmp openssl rpm-libs tcp_wrappers-libs libcurl).each do |pkg|
          package pkg
        end
    end

    if node['mongodb']['edition'] == 'enterprise'
      yum_repository "mongodb-enterprise-#{node[:mongodb][:version]}" do
        description "MongoDB Enterprise Repository"
        baseurl "https://repo.mongodb.com/yum/redhat/$releasever/mongodb-enterprise/#{node['mongodb']['version']}/$basearch/"
        gpgkey "https://www.mongodb.org/static/pgp/server-#{node['mongodb']['version']}.asc"
        gpgcheck true
        enabled true
        action :create
      end

      package 'mongodb-enterprise' do
        action :install
      end

    end

    if node['mongodb']['edition'] == 'community'
      yum_repository "mongodb-org-#{node[:mongodb][:version]}" do
        description "MongoDB Repository"
        baseurl "https://repo.mongodb.org/yum/redhat/$releasever/mongodb-org/#{node['mongodb']['version']}/x86_64/"
        gpgkey "https://www.mongodb.org/static/pgp/server-#{node['mongodb']['version']}.asc"
        gpgcheck true
        enabled true
        action :create
      end

      package 'mongodb-org' do
        action :install
      end

      # Create /var/lib/mongo
      directory "#{node['mongodb']['data_path']}" do 
        path node['mongodb']['data_path']
        mode '0755'
        owner 'mongod'
        group 'mongod'
        action :create
        not_if { ::File.directory?("#{node['mongodb']['data_path']}") } 
      end

      directory "node['mongodb']['pid']['path']" do
        path node['mongodb']['pid']['path']
        mode '0755'
        owner 'mongod'
        group 'mongod'
        action :create
        not_if { ::File.directory?("#{node['mongodb']['pid']['path']}") } 
      end

      template "#{node['mongodb']['config_file']}" do
       source 'mongod.conf.erb'
       variables({
          :dbpath => node['mongodb']['data_path'],
          :logpath => node['mongodb']['log_path'],
          :mongopid => node['mongodb']['pid']['file'],
          :mongoport => node['mongodb']['port']
       })
       mode '0644'
       owner 'root'
       group 'root'
       # notifies :restart, 'service[mongod]'
      end

    end

    # Common to all rhel versions
    service 'mongod' do
      supports :status => true, :start => true, :stop => true, :restart => true
      action [:enable, :start]
    end
  when 'suse'
  # SUSE related code comes here

end # ends case platform

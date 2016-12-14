#
# Cookbook Name:: mongodb
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

case node[:platform]
  when 'redhat','centos'
    case node['platform']['version']
      when "~6"
        %w(cyrus-sasl cyrus-sasl-plain cyrus-sasl-gssapi krb5-libs net-snmp openssl libcurl).each do |pkg|
          package pkg
        end
      when "~7"
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

      package mongodb-enterprise

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

      package mongodb-org

    end

    # Common to all rhel versions
    service 'mongod' do
      supports :status => true, :start => true, :stop => true, :restart => true
      action [:enable, :start]
    end
  when 'suse'
  # SUSE related code comes here

end # ends case platform

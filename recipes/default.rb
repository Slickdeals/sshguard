#
# Cookbook Name:: sshguard
# Recipe:: default
#
# Copyright (c) 2014 Slickdeals.net, All Rights Reserved.

include_recipe "sshguard::install_#{node['sshguard']['install_method']}"

directory '/etc/sshguard' do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

template '/etc/default/sshguard' do
  source 'default_sshguard.erb'
  owner 'root'
  group 'root'
  mode '0644'
  variables({
              :logfile  => node['sshguard']['logfiles'],
              :fw => node['sshguard']['use_iptables_cookbook'],
              :a => node['sshguard']['safety_thresh'],
              :p => node['sshguard']['block_duration'],
              :s => node['sshguard']['attack_interim'],
              :b => node['sshguard']['blacklist']
            })
  notifies :restart, "service[sshguard]"
end

template "/etc/sshguard/whitelist" do
  source "whitelist.erb"
  owner "root"
  group "root"
  mode '0644'
  variables({
              :whitelist  => node['sshguard']['whitelistips']
            })
  notifies :restart, "service[sshguard]"
end

cookbook_file '/etc/init.d/sshguard' do
  source "sshguardinit.sh"
  action :create
  owner 'root'
  group 'root'
  mode '0755'
  notifies :restart, "service[sshguard]"
end

service "sshguard" do
  supports :restart => true, :status => true, :reload => true
  action [:enable, :start]
end

if node['sshguard']['use_iptables_cookbook']
  # Sets up iptables
  include_recipe 'iptables'
  # Creates the iptables rules for sshguard
  iptables_rule "sshguard"
end

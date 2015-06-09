#
# Cookbook Name:: sshguard
# Recipe:: install_source
#
# Copyright (c) 2014 Slickdeals.net, All Rights Reserved.
#

include_recipe 'build-essential'

download_file = ::File.join(Chef::Config[:file_cache_path], "sshguard-#{node['sshguard']['source']['version']}.tar.bz2")

# Download source tarball.
remote_file download_file do
  source node['sshguard']['source']['url']
  checksum node['sshguard']['source']['checksum']
  mode "0644"
  action :create
end

make_cmd = "make TARGET=#{node['sshguard']['source']['target_os']}"

bash "compile_sshguard" do
  cwd Chef::Config[:file_cache_path]
  code <<-EOH
    tar jxf sshguard-#{node['sshguard']['source']['version']}.tar.bz2
    cd sshguard-#{node['sshguard']['source']['version']}
    ./configure --with-firewall=iptables
    #{make_cmd} && make install
  EOH
  not_if "sshguard -v 2>&1 | grep #{node['sshguard']['source']['version']}"
end

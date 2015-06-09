#
# Cookbook Name:: sshguard
# Recipe:: install_package
#
# Copyright (c) 2014 Slickdeals.net, All Rights Reserved.

package "sshguard" do
  version node['sshguard']['package']['version'] if node['sshguard']['package']['version']
  action :install
end

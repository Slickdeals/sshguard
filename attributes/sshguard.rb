#
# Cookbook Name:: sshguard
# Recipe:: default
#
# Copyright (c) 2014 Slickdeals.net, All Rights Reserved.
#

case node["platform_family"]
when 'debian'
  default['sshguard']['install_method'] = 'package'
  default['sshguard']['logfiles'] = ["/var/log/auth.log"]
when "rhel"
  default['sshguard']['install_method'] = 'source'
  default['sshguard']['logfiles'] = ["/var/log/secure"]
end

default['sshguard']['source']['version'] = '1.5'
default['sshguard']['source']['url'] = 'https://downloads.sourceforge.net/project/sshguard/sshguard/sshguard-1.5/sshguard-1.5.tar.bz2'
default['sshguard']['source']['checksum'] = 'b537f8765455fdf8424f87d4bd695e5b675b88e5d164865452137947093e7e19'
default['sshguard']['source']['target_os'] = 'generic'

default['sshguard']['package']['version'] = nil

default['sshguard']['whitelistips'] = [nil]
default['sshguard']['initfirewall'] = false
default['sshguard']['safety_thresh'] = '40'
default['sshguard']['block_duration'] = '420'
default['sshguard']['attack_interim'] = '1200'
default['sshguard']['blacklist'] = nil

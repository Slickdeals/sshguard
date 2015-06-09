name             'sshguard'
maintainer       'swagopopotamus'
maintainer_email 'bofh@slickdeals.net'
license          'BSD'
description      'Installs/Configures sshguard'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.6'

recipe "sshguard", "Installs and configures sshguard"

%w(debian ubuntu centos redhat).each do |os|
  supports os
end

depends           "build-essential"
depends           "iptables"
depends           "firewall"

attribute "sshguard/whitelistips",
  :display_name => "SSHGuard Whitelist IP Addresses",
  :description => "An array of IP Addresses that will not be blocked",
  :required => "optional",
  :type => "array"

attribute "sshguard/user",
  :display_name => "sshguard user",
  :description => "User that sshguard runs as.",
  :required => "optional",
  :default => "sshguard"

attribute "sshguard/group",
  :display_name => "sshguard group",
  :description => "Group that sshguard runs as.",
  :required => "optional",
  :default => "sshguard"

attribute "sshguard/install_method",
  :display_name => "sshguard install method",
  :description => "Determines which method is used to install sshguard, must be 'source' or 'package'. defaults to 'package'.",
  :required => "recommended",
  :choice => %w(package source),
  :default => "package"

attribute "sshguard/conf_dir",
  :display_name => "sshguard config directory",
  :description => "The location of the sshguard config file.",
  :required => "optional",
  :default => "/etc/sshguard"

attribute "sshguard/source/version",
  :display_name => "sshguard source version",
  :description => "The version of sshguard to install.",
  :required => "optional",
  :default => "1.5"

attribute "sshguard/source/url",
  :display_name => "sshguard source URL",
  :description => "The full URL to the sshguard source package.",
  :required => "optional",
  :default => "https://downloads.sourceforge.net/project/sshguard/sshguard/sshguard-1.5/sshguard-1.5.tar.bz2"

attribute "sshguard/source/checksum",
  :display_name => "sshguard source checksum",
  :description => "The checksum of the sshguard source package.",
  :required => "optional",
  :default => "f8f713bfb3f5c9877b34f6821426a22a7eec8df3"

attribute "sshguard/source/target_os",
  :display_name => "sshguard source target OS",
  :description => "The target used to make sshguard.",
  :required => "optional",
  :default => "generic"

attribute "sshguard/source/target_cpu",
  :display_name => "sshguard source target CPU",
  :description => "The target cpu used to make sshguard.",
  :required => "optional",
  :default => ""

attribute "sshguard/source/target_arch",
  :display_name => "sshguard source target arch",
  :description => "The target arch used to make sshguard.",
  :required => "optional",
  :default => ""

attribute "sshguard/package/version",
  :display_name => "sshguard package version",
  :description => "The version of sshguard to install.",
  :required => "optional"

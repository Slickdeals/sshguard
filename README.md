# sshguard

sshguard Cookbook
================
Installs sshguard and configures host blocking with iptables


Requirements
------------
### Platforms
- Ubuntu (10.04+) __You will need to use other means to ensure that ufw is activated.__
- CentOS (6+)


Attributes
----------
- `node['sshguard']['install_method']` - determines which method is used to install sshguard, must be 'source' or 'package'. defaults to 'package'
- `node['sshguard']['whitelist_ips']` - an array of ip addresses that will be excluded from blocking
- `node['sshguard']['use_iptables_cookbook']` - set to false if you do not want this to call the iptables cookbook to initalize iptables. When false the upstream init script is used to inject the rules directly into iptables (default: true)
- `node['sshguard']['safety_thresh']` - Block an attacker after it incurred a total dangerousness exceeding sAfety_thresh. (Default: 40)
- `node['sshguard']['block_duration']` - Release blocked addr no sooner than secs after blocked first time. sshguard will release between X and 3/2 * X seconds after blocking it.  (Default: 7*60)
- `node['sshguard']['attack_interim']` - Forget about an address after secs seconds. If host A issues one attack every this many seconds, it will never be blocked.  (Default: 20*60)
- `node['sshguard']['logfiles']` - list of log sources for the Log Sucker to monitor.
- `node['sshguard']['blacklist']` - set the blacklist value (see SSHGuard Documentation for information on the -b flag)
- `node['sshguard']['source']['version']` - the version of sshguard to install
- `node['sshguard']['source']['url']` - the full URL to the sshguard source package
- `node['sshguard']['source']['checksum']` - the checksum of the sshguard source package
- `node['sshguard']['source']['prefix']` - the prefix used to `make install` sshguard
- `node['sshguard']['source']['target_os']` - the target used to `make` sshguard
- `node['sshguard']['source']['target_cpu']` - the target cpu used to `make` sshguard
- `node['sshguard']['source']['target_arch']` - the target arch used to `make` sshguard
- `node['sshguard']['package']['version']` - the version of sshguard to install, default latest


Recipes
-------
### default
Installs and configures SSHGuard.

If the `node['iptables']['use_iptables_cookbook']` attribute is set to true (default behavior) it will use the iptables cookbook to configure a new chain for sshguard to drop traffic from offenders

If it is set to false then the cookbook will enable the upstream package's method which calls the rule add commands in sshguard's init script. In this case you will need to enable iptables and ensure it is working elsewhere

### install_package
Installs sshguard through the package manager. Used by the `default` recipe.

### install_source
Installs sshguard from source. Used by the `default` recipe.


Usage
-----
Set any attrpibutes needed and call `recipe[sshguard:default]` in your runlist or from your wrapper


## License & Authors
- Authors:
    - Jonathan Temple <bofh@slickdeals.net>
    - David Aronsohn <hipster@slickdeals.net>


```text
Copyright (c) 2015 Slickdeals, LLC
All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

3. Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
```

require 'serverspec'

describe service('sshguard') do
  it { should be_running }
  it { should be_enabled }
end

describe file('/etc/default/sshguard') do
  it { should be_file }
  its(:content) { should include 'ENABLE_FIREWALL=1' }
  its(:content) { should include '-a 40 -p 420 -s 1200' }
end

describe file('/etc/sshguard/whitelist') do
  it { should be_file }
  its(:content) { should include '1.2.3.4' }
  its(:content) { should include '5.6.7.8' }
end

describe command('iptables -L') do
  its(:stdout) { should include 'sshguard   all  --  anywhere' }
  its(:stdout) { should include 'Chain sshguard' }
end

describe port(22) do
  it { should be_listening }
end

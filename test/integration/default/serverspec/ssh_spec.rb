# frozen_string_literal: true
require 'serverspec'

set :backend, :exec

ssh_service = {
  'redhat' => 'sshd'
}.fetch(os[:family], 'ssh')

describe package('openssh-server') do
  it { should be_installed }
end

describe service(ssh_service) do
  it { should be_running }
end

describe port(22) do
  it { should be_listening }
end

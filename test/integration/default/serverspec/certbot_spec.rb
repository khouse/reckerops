# frozen_string_literal: true

require 'serverspec'

set :backend, :exec

describe package('certbot') do
  it { should be_installed }
end

describe command('certbot --version') do
  its(:exit_status) { should eq 0 }
end

describe cron do
  it { should have_entry '0 1 * * sun /reckerops/certbot-renew.sh' }
end

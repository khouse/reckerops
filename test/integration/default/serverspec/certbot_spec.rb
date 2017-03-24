# frozen_string_literal: true
require 'serverspec'

set :backend, :exec

describe command('certbot --version') do
  its(:exit_status) { should eq 0 }
end

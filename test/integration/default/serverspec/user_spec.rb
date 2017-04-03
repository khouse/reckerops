# frozen_string_literal: true

require 'serverspec'

set :backend, :exec

describe user('alex') do
  it { should belong_to_group('sudo') }
  it { should have_home_directory('/home/alex') }
  it { should have_login_shell('/bin/bash') }
end

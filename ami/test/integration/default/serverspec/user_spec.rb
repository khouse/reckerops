require 'serverspec'

set :backend, :exec

describe 'user' do
  me = user('alex')

  it 'should be a sudoer' do
    expect(me).to belong_to_group('sudo')
  end

  it 'should have a home directory' do
    expect(me).to have_home_directory('/home/alex')
  end

  it 'should have a shell' do
    expect(me).to have_login_shell('/bin/bash')
  end
end

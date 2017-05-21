require 'json'
require 'yaml'
require 'aws-sdk'

def stack_output(value)
  _, stack, key = value.split(':')
  outputs = Aws::CloudFormation::Stack.new(name: stack).outputs
  outputs.find { |o| o.output_key == key }.output_value
end

pillar = {}
pillar['key'] = ENV['CLOUDFLARE_API_KEY']
pillar['email'] = ENV['CLOUDFLARE_EMAIL']

zones = YAML.load_file('./zones.yml')
zones.each do |_, info|
  info.fetch('records', []).each do |r|
    if r.fetch('content', '').start_with? 'stack_output:'
      r['content'] = stack_output(r['content'])
    end
  end
end
pillar['zones'] = zones

system('salt-call --local saltutil.sync_states')
system("salt-call --local state.sls dns --state-output=mixed pillar='#{pillar.to_json}'")

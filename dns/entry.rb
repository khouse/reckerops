require 'json'
require 'yaml'

pillar = {}
pillar['zones'] = YAML.load_file('/zones.yml')
pillar['key'] = ENV['CLOUDFLARE_API_KEY']

system('salt-call --local saltutil.sync_states')
system("salt-call --local state.sls dns --state-output=mixed pillar='#{pillar.to_json}'")

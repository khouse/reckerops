import os
import json

import yaml
import boto3


def stack_output(content):
    cloudformation = boto3.resource('cloudformation')
    _, stack, key = content.split(':')
    outputs = cloudformation.Stack(stack).outputs

    for output in outputs:
        if output['OutputKey'] == key:
            return output['OutputValue']

    raise Exception('Could not find output "{}" in stack "{}"'.format(key, stack))


def main():
    zones = yaml.load(open('./zones.yml'))

    for zone, info in zones.iteritems():
        for record in info.get('records', []):
            if record.get('content', '').startswith('stack_output:'):
                old = record['content']
                new = stack_output(old)
                print('changing {} to {}'.format(old, new))
                record['content'] = new

    pillar = json.dumps({
        'key': os.environ['CLOUDFLARE_API_KEY'],
        'email': os.environ['CLOUDFLARE_EMAIL'],
        'zones': zones
    })

    os.system('salt-call --local saltutil.sync_states')
    os.system("salt-call --local --retcode-passthrough state.sls dns --state-output=mixed pillar='{}'".format(pillar))


if __name__ == '__main__':
    main()

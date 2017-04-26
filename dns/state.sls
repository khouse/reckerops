{% for zone, info in pillar.get('zones', {}).iteritems() %}
{{ zone }}:
  cloudflare.manage_zone_records:
    - zone:
        auth_key: {{ pillar['key'] }}
        auth_email: {{ pillar['email'] }}
        zone_id: {{ info['id'] }}
        records:
          {% for record in info.get('records', []) %}
          - name: {{ record['name'] }}
            content: {{ record['content'] }}
            proxied: {{ record.get('proxied', False) }}
            type: {{ record.get('type', 'A') }}
          {% endfor %}
{% endfor %}

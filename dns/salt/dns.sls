{% for zone in pillar.get('zones', []) %}
dns-zones-{{ zone['id'] }}:
  cloudflare.manage_zone_records:
    - zone:
        auth_email: {{ zone['email'] }}
        auth_key: {{ zone['key'] }}
        zone_id: {{ zone['id'] }}
        records:
          {% for record in zone.get('records', []) %}
          - name: {{ record['name'] }}
            content: {{ record['content'] }}
            proxied: {{ record.get('proxied', False) }}
          {% endfor %}
{% endfor %}

from fabric.api import run, env
from fabric.operations import put

env.use_ssh_config = True


def repo():

    """Add saltstack repo"""

    put('/etc/apt/sources.list.d/saltstack.list', 'files/saltstack.list')
    put('/tmp/saltstack.pub', 'files/saltstack.list')
    run('apt-key add /tmp/saltstack.pub && apt-get update')

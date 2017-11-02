from fabric.api import run, env
from fabric.operations import put
from fabric.contrib.files import upload_template

env.use_ssh_config = True


def repo():

    """Add saltstack repo"""

    put('files/saltstack.list', '/etc/apt/sources.list.d/saltstack.list')
    put('files/saltstack.pub', '/tmp/saltstack.pub')
    run('apt-key add /tmp/saltstack.pub && apt-get update')


def master():

    """Configure a master"""

    repo()
    run('apt-get install -y salt-master python-git')
    put('files/master.yml', '/etc/salt/master')
    run('systemctl enable salt-master')
    run('systemctl restart salt-master')


def minion(master_host='saltmaster.alexrecker.com', worker=True, proxy=False, master=False):

    """Configure a minion"""

    repo()
    run('apt-get install -y salt-minion')

    roles = []

    if worker:
        roles.append('worker')
    if proxy:
        roles.append('proxy')
    if master:
        roles.append('master')

    upload_template('files/minion.yml', '/etc/salt/minion', context={
        'master': master_host,
        'roles': roles
    }, use_jinja=True)

    run('systemctl enable salt-minion')
    run('systemctl restart salt-minion')

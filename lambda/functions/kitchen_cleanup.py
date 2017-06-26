import boto3


def handler(*args, **kwargs):
    ec2 = boto3.resource('ec2')

    ec2.instances.filter(Filters=[{
        'Name': 'tag-key',
        'Values': ['kitchen-cleanup']
    }]).terminate()

    mark_for_deletion = ec2.instances.filter(Filters=[{
        'Name': 'tag:created-by',
        'Values': ['test-kitchen'],
    }])

    for instance in mark_for_deletion:
        instance.create_tags(Tags=[{
            'Key': 'kitchen-cleanup',
            'Value': 'true'
        }])

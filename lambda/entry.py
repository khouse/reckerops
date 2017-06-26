import os
import errno
import tempfile
import shutil
import contextlib
import json
import zipfile

import boto3
import botocore


HERE = os.path.dirname(os.path.realpath(__file__))


class LambdaStack(object):
    stack_name = 'lambda'
    stack_template = json.dumps({
        'Description': 'Lambda Builds and Packages',
        'Resources': {
            'Bucket': {
                'Type': 'AWS::S3::Bucket',
                'Properties': {
                    'BucketName': 'reckerops-lambda',
                    'AccessControl': 'PublicRead'
                }
            }
        },
        'Outputs': {
            'BucketName': {
                'Description': 'Name of the bucket',
                'Value': {
                    'Ref': 'Bucket',
                }
            },
            'BucketArn': {
                'Description': 'ARN of the bucket',
                'Value': {
                    'Fn::GetAtt': ['Bucket', 'Arn']
                }
            }
        }
    }, indent=True)

    def as_resource(self):
        return boto3.resource('cloudformation').Stack(self.stack_name)

    def as_client(self):
        return self.as_resource().meta.client

    def apply(self):
        if self.exists():
            self.update()
        else:
            self.create()

    def exists(self):
        try:
            assert self.as_resource().stack_id
            return True
        except botocore.exceptions.ClientError:
            return False

    def create(self):
        client = self.as_client()
        waiter = client.get_waiter('stack_create_complete')
        client.create_stack(
            StackName=self.stack_name,
            TemplateBody=self.stack_template,
        )
        waiter.wait(StackName=self.stack_name)

    def update(self):
        stack = self.as_resource()
        waiter = stack.meta.client.get_waiter('stack_update_complete')
        try:
            stack.update(TemplateBody=self.stack_template)
        except botocore.exceptions.ClientError as e:
            if 'No updates are to be performed' in e.message:
                return
            raise e
        waiter.wait(StackName=self.stack_name)


@contextlib.contextmanager
def temp_directory():
    path = tempfile.mkdtemp()
    try:
        os.chdir(path)
        yield
    finally:
        os.chdir(HERE)
        try:
            shutil.rmtree(path)
        except OSError as e:
            if e.errno != errno.ENOENT:
                raise e


def main():
    stack = LambdaStack()
    stack.apply()

    for function in os.listdir(os.path.join(HERE, 'functions')):
        name, ext = os.path.splitext(function)

        if not ext == '.py':
            continue

        with temp_directory():
            os.mkdir('package')
            shutil.copyfile(
                os.path.join(HERE, 'functions', function),
                'package/function.py'
            )
            with zipfile.ZipFile('{}.zip'.format(name), 'w') as z:
                os.chdir('package')
                for root, dirs, files in os.walk('.'):
                    for f in files:
                        z.write(os.path.join(root, f))
                os.chdir('..')

            target = '{}.zip'.format(name)
            bucket = boto3.resource('s3').Object('reckerops-lambda', target)
            bucket.upload_file(target)


if __name__ == '__main__':
    main()

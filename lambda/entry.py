import json

import boto3
import botocore


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
                print('No Updates')
                return
            raise e
        waiter.wait(StackName=self.stack_name)


def main():
    stack = LambdaStack()
    stack.apply()


if __name__ == '__main__':
    main()

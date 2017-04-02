# frozen_string_literal: true

# rubocop:disable BlockLength
SparkleFormation.new(:statics) do
  resources.bucket do
    Type 'AWS::S3::Bucket'
    Properties do
      BucketName 'astuaryart.com'
      AccessControl 'PublicRead'
      WebsiteConfiguration do
        IndexDocument 'index.html'
        ErrorDocument '404.html'
      end
    end
  end

  resources.bucket_policy do
    Type 'AWS::S3::BucketPolicy'
    Properties do
      Bucket ref!(:bucket)
      PolicyDocument do
        Statement [
          Principal: '*',
          Action: ['s3:GetObject'],
          Effect: 'Allow',
          Resource: 'arn:aws:s3:::astuaryart.com/*'
        ]
      end
    end
  end

  resources.bucket_redirect do
    Type 'AWS::S3::Bucket'
    Properties do
      BucketName 'www.astuaryart.com'
      AccessControl 'BucketOwnerFullControl'
      WebsiteConfiguration do
        RedirectAllRequestsTo do
          HostName ref!(:bucket)
        end
      end
    end
  end

  resources.bucket_redirect_policy do
    Type 'AWS::S3::BucketPolicy'
    Properties do
      Bucket ref!(:bucket_redirect)
      PolicyDocument do
        Statement [
          Principal: '*',
          Action: ['s3:GetObject'],
          Effect: 'Allow',
          Resource: 'arn:aws:s3:::www.astuaryart.com/*'
        ]
      end
    end
  end

  dynamic!(
    :user, :build_user,
    user_name: join!(stack_name!, '-build-', region!),
    policy_name: 'BuildUserPolicy', effect: 'Allow',
    resource: 'arn:aws:s3:::astuaryart.com/*',
    action: [
      's3:PutObject'
    ]
  )
end

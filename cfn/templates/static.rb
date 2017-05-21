SparkleFormation.new(:static) do
  Description 'Stack for a static website hosted on S3'

  parameters.domain do
    Type 'String'
    Description 'example.com'
  end

  resources.user do
    Type 'AWS::IAM::User'
    Properties do
      UserName join!(stack_name!, '-', region!)
      Policies [
        PolicyName: 'PublishPolicy',
        PolicyDocument: {
          Version: '2012-10-17',
          Statement: [
            {
              Effect: 'Allow',
              Action: 's3:PutObject',
              Resource: join!('arn:aws:s3:::', ref!(:domain), '/*')
            }
          ]
        }
      ]
    end
  end

  resources.access_key do
    Type 'AWS::IAM::AccessKey'
    Properties do
      Serial 0
      Status 'Active'
      UserName ref!(:user)
    end
  end

  resources.bucket do
    Type 'AWS::S3::Bucket'
    Properties do
      BucketName ref!(:domain)
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
          Action: 's3:GetObject',
          Effect: 'Allow',
          Resource: join!('arn:aws:s3:::', ref!(:domain), '/*')
        ]
      end
    end
  end

  resources.bucket_redirect do
    Type 'AWS::S3::Bucket'
    Properties do
      BucketName join!('www.', ref!(:domain))
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
          Resource: join!('arn:aws:s3:::www.', ref!(:domain), '/*')
        ]
      end
    end
  end

  outputs.url do
    Description 'URL for the website'
    Value attr!(:bucket, :WebsiteURL)
  end

  outputs.url_redirect do
    Description 'URL for the website www redirect'
    Value attr!(:bucket_redirect, :WebsiteURL)
  end

  outputs.access_key_id do
    Description 'AWS_ACCESS_KEY_ID'
    Value ref!(:access_key)
  end

  outputs.access_key_secret do
    Description 'AWS_SECRET_ACCESS_KEY'
    Value attr!(:access_key, :SecretAccessKey)
  end
end

SparkleFormation.new(:static) do
  Description 'Stack for a static website hosted on S3'

  parameters.domain do
    Type 'String'
    Description 'example.com'
  end

  parameters.access_key_serial do
    Type 'Number'
    Default 0
    Description 'Increment to rotate access key'
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

  dynamic!(:r_bucket_web, :bucket, domain: ref!(:domain))
  dynamic!(:r_bucket_web_redirect, :bucket_redirect, domain: join!('www.', ref!(:domain)), target: ref!(:domain))

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

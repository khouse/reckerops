SparkleFormation.new(:demo) do
  parameters.domain do
    Type 'String'
    Default 'demo.alexrecker.com'
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

  outputs.url do
    Description 'URL for the website'
    Value attr!(:bucket, :WebsiteURL)
  end
end

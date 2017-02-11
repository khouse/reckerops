SparkleFormation.dynamic(:static) do |_config={}|
  parameters.domain do
    Description 'Domain of the static site'
    Type 'String'
  end

  resources.zone do
    Type 'AWS::Route53::HostedZone'
    Properties do
      Name ref!(:domain)
    end
  end

  resources.bucket do
    Type 'AWS::S3::Bucket'
    Properties do
      BucketName ref!(:domain)
      AccessControl 'PublicRead'
      WebsiteConfiguration do
        IndexDocument 'index.html'
      end
    end
  end

  if _config.fetch(:www, false)
    resources.wwwbucket do
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
  end

  outputs.url do
    Description 'Website URL'
    Value attr!(:bucket, 'WebsiteURL')
  end
end

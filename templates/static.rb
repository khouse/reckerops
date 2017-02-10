SparkleFormation.new(:static) do
  parameters.domain do
    Description 'Domain of the static site'
    Type 'String'
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

  outputs.url do
      Description 'Website URL'
      Value attr!(:bucket, 'WebsiteURL')
  end
end

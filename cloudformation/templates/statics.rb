# frozen_string_literal: true

# rubocop:disable BlockLength
SparkleFormation.new(:statics) do
  resources.astuary_bucket do
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

  resources.astuary_bucket_redirect do
    Type 'AWS::S3::Bucket'
    Properties do
      BucketName 'www.astuaryart.com'
      AccessControl 'BucketOwnerFullControl'
      WebsiteConfiguration do
        RedirectAllRequestsTo do
          HostName ref!(:astuary_bucket)
        end
      end
    end
  end

  outputs.astuary_url do
    Description 'URL for Astuary Art'
    Value attr!(:astuary_bucket, 'WebsiteURL')
  end
end

SparkleFormation.new(:sriram) do
  resources.scrabble_bucket do
    Type 'AWS::S3::Bucket'
    Properties do
      BucketName 'scrabble.sarahrecker.com'
      AccessControl 'PublicRead'
      WebsiteConfiguration do
        IndexDocument 'index.html'
        ErrorDocument '404.html'
      end
    end
  end

  resources.scrabble_bucket_policy do
    Type 'AWS::S3::BucketPolicy'
    Properties do
      Bucket 'scrabble.sarahrecker.com'
      PolicyDocument do
        Statement [
          Principal: '*',
          Action: 's3:GetObject',
          Effect: 'Allow',
          Resource: 'arn:aws:s3:::scrabble.sarahrecker.com/*'
        ]
      end
    end
  end

  outputs.scrabble_url { Value attr!(:scrabble_bucket, :WebsiteURL) }
end

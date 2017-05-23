SparkleFormation.dynamic(:r_bucket_web) do |resource, config = {}|
  resources do
    set!("#{resource}") do
      Type 'AWS::S3::Bucket'
      Properties do
        BucketName config.fetch(:domain)
        AccessControl 'PublicRead'
        WebsiteConfiguration do
          IndexDocument config.fetch(:index, 'index.html')
          ErrorDocument config.fetch(:error, '404.html')
        end
      end
    end

    set!("#{resource}_policy") do
      Type 'AWS::S3::BucketPolicy'
      Properties do
        Bucket config.fetch(:domain)
        PolicyDocument do
          Statement [
            Principal: '*',
            Action: 's3:GetObject',
            Effect: 'Allow',
            Resource: join!('arn:aws:s3:::', config.fetch(:domain), '/*')
          ]
        end
      end
    end
  end
end

SparkleFormation.dynamic(:r_bucket_web_redirect) do |resource, config = {}|
  resources do
    set!("#{resource}") do
      Type 'AWS::S3::Bucket'
      Properties do
        BucketName config.fetch(:domain)
        AccessControl 'BucketOwnerFullControl'
        WebsiteConfiguration do
          RedirectAllRequestsTo do
            HostName config.fetch(:target)
          end
        end
      end
    end
    set!("#{resource}_policy") do
      Type 'AWS::S3::BucketPolicy'
      Properties do
        Bucket config.fetch(:domain)
        PolicyDocument do
          Statement [
            Principal: '*',
            Action: ['s3:GetObject'],
            Effect: 'Allow',
            Resource: join!('arn:aws:s3:::', config.fetch(:domain), '/*')
          ]
        end
      end
    end
  end
end

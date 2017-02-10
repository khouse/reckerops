SparkleFormation.new(:static) do
  parameters.domain do
    description 'Domain of the static site'
    type 'String'
  end
  resources.bucket do
    type 'AWS::S3::Bucket'
    Properties do
      BucketName ref!(:domain)
      AccessControl 'PublicRead'
    end
  end
end

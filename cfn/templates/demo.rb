SparkleFormation.new(:demo) do
  parameters.domain do
    Type 'String'
    Default 'demo.alexrecker.com'
  end

  dynamic!(:r_bucket_web, :bucket, domain: ref!(:domain))

  outputs.url do
    Description 'URL for the website'
    Value attr!(:bucket, :WebsiteURL)
  end
end

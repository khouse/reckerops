SparkleFormation.new(:sriram) do
  dynamic!(:r_bucket_web, :scrabble_bucket, domain: 'scrabble.sarahrecker.com')
  outputs.scrabble_url { Value attr!(:scrabble_bucket, :WebsiteURL) }
end

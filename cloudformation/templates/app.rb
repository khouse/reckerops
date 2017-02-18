SparkleFormation.new(:vpc) do
  description 'A simple public service'
  dynamic!(:network)
end

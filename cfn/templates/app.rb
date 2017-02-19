SparkleFormation.new(:app) do
  description 'A simple public service'
  dynamic!(:network)
  dynamic!(:security, ref!(:network_vpc),
           :ssh_anywhere => true,
           :http_anywhere => true,
           :https_anywhere => true)
end

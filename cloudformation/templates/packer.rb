SparkleFormation.new(:packer) do
  description 'A packer-ready network stack'
  dynamic!(:network)
  dynamic!(:security, ref!(:network_vpc),
           :description => 'Allow SSH to packer builders',
           :ssh_anywhere => true)
end

SparkleFormation.new(:vpc) do
  description 'A packer-ready network stack'

  dynamic!(:network)

  resources.security_group do
    Type 'AWS::EC2::SecurityGroup'
    Properties do
      GroupDescription 'Allow SSH to packer builders'
      VpcId ref!(:network_vpc)
      Tags tags!({:Name => stack_name!})
      SecurityGroupIngress do
        IpProtocol 'tcp'
        FromPort '22'
        ToPort '22'
        CidrIp '0.0.0.0/0'
      end
    end
  end
end

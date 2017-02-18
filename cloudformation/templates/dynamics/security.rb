SparkleFormation.dynamic(:security) do |_vpc, _config|
  resources.security_group do
    Type 'AWS::EC2::SecurityGroup'
    Properties do
      VpcId _vpc
      GroupDescription _config[:description] || join!('Security group for ', stack_name!)
      Tags tags!({:Name => stack_name!})
    end
  end

  if _config[:ssh_anywhere]
    resources.security_group_ingress_ssh_anywhere do
      Type 'AWS::EC2::SecurityGroupIngress'
      Properties do
        GroupName ref!(:security_group)
        FromPort 22
        ToPort 22
        IpProtocol 'TCP'
        CidrIp '0.0.0.0/0'
      end
    end
  end

  if _config[:http_anywhere]
    resources.security_group_ingress_http_anywhere do
      Type 'AWS::EC2::SecurityGroupIngress'
      Properties do
        GroupName ref!(:security_group)
        FromPort 80
        ToPort 80
        IpProtocol 'TCP'
        CidrIp '0.0.0.0/0'
      end
    end
  end

  if _config[:https_anywhere]
    resources.security_group_ingress_https_anywhere do
      Type 'AWS::EC2::SecurityGroupIngress'
      Properties do
        GroupName ref!(:security_group)
        FromPort 443
        ToPort 443
        IpProtocol 'TCP'
        CidrIp '0.0.0.0/0'
      end
    end
  end
end

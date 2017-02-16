SparkleFormation.new(:vpc) do
  parameters do
    cidr do
      Type 'String'
      Description 'CIDR Block for the VPC'
    end
    subcidr do
      Type 'String'
      Description 'CIDR Block for the Subnet'
    end
  end

  resources do
    vpc do
      Type 'AWS::EC2::VPC'
      Properties do
        CidrBlock ref!(:cidr)
        Tags tags!({:Name => stack_name!})
      end
    end
    subnet do
      Type 'AWS::EC2::Subnet'
      Properties do
        CidrBlock ref!(:subcidr)
        VpcId ref!(:vpc)
        Tags tags!({:Name => stack_name!})
      end
    end
    sg do
      Type 'AWS::EC2::SecurityGroup'
      Properties do
        GroupDescription 'Allow SSH to packer builders'
        VpcId ref!(:vpc)
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

  outputs do
    vpc_id do
      value ref!(:vpc)
    end
    subnet_id do
      value ref!(:subnet)
    end
    sg_id do
      value ref!(:sg)
    end
  end
end

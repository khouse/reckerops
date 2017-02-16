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
  end

  outputs do
    vpc do
      value ref!(:vpc)
    end
    subnet do
      value ref!(:subnet)
    end
  end
end

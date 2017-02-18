SparkleFormation.dynamic(:network) do
  # A simple vpc with a public gateway and a single subnet.

  parameters.network_vpc_cidr do
    Type 'String'
    Description 'CIDR Block for the VPC'
    Default '10.0.0.0/16'
  end

  parameters.network_subnet_cidr do
    Type 'String'
    Description 'CIDR Block for the Subnet'
    Default '10.0.0.0/24'
  end

  resources.network_vpc do
    Type 'AWS::EC2::VPC'
    Properties do
      CidrBlock ref!(:network_vpc_cidr)
      Tags tags!({:Name => stack_name!})
    end
  end

  resources.network_gateway do
    Type 'AWS::EC2::InternetGateway'
    Properties do
      Tags tags!({:Name => stack_name!})
    end
  end

  resources.network_gateway_attachment do
    Type 'AWS::EC2::VPCGatewayAttachment'
    Properties do
      InternetGatewayId ref!(:network_gateway)
      VpcId ref!(:network_vpc)
    end
  end

  resources.network_route_table do
    Type 'AWS::EC2::RouteTable'
    Properties do
      VpcId ref!(:network_vpc)
      Tags tags!({:Name => stack_name!})
    end
  end

  resources.network_public_route do
    Type 'AWS::EC2::Route'
    Properties do
      GatewayId ref!(:network_gateway)
      RouteTableId ref!(:network_route_table)
      DestinationCidrBlock '0.0.0.0/0'
    end
  end

  resources.network_subnet do
    Type 'AWS::EC2::Subnet'
    Properties do
      CidrBlock ref!(:network_subnet_cidr)
      MapPublicIpOnLaunch true
      VpcId ref!(:network_vpc)
      Tags tags!({:Name => stack_name!})
    end
  end

  resources.network_route_table_attachment do
    Type 'AWS::EC2::SubnetRouteTableAssociation'
    Properties do
      RouteTableId ref!(:network_route_table)
      SubnetId ref!(:network_subnet)
    end
  end
end

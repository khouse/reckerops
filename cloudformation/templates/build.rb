# frozen_string_literal: true

# rubocop:disable BlockLength
SparkleFormation.new(:build) do
  Description 'Basic public ec2 network for kitchen builds'
  parameters.vpc_cidr do
    Type 'String'
    Description 'CIDR Block for the VPC'
    Default '10.0.0.0/16'
  end
  parameters.subnet_cidr do
    Type 'String'
    Description 'CIDR Block for the Subnet'
    Default '10.0.0.0/16'
  end
  dynamic!(
    :user, :user,
    user_name: join!(stack_name!, '-', region!),
    policy_name: 'BuildEC2Policy', effect: 'Allow',
    resource: '*', action: [
      'cloudformation:*',
      'ec2:*',
      'sns:*'
    ]
  )
  resources.vpc do
    Type 'AWS::EC2::VPC'
    Properties do
      CidrBlock ref!(:vpc_cidr)
      Tags tags!(name: stack_name!)
    end
  end
  resources.gateway do
    Type 'AWS::EC2::InternetGateway'
    Properties do
      Tags tags!(name: stack_name!)
    end
  end
  resources.gateway_attachment do
    Type 'AWS::EC2::VPCGatewayAttachment'
    Properties do
      InternetGatewayId ref!(:gateway)
      VpcId ref!(:vpc)
    end
  end
  resources.route_table do
    Type 'AWS::EC2::RouteTable'
    Properties do
      VpcId ref!(:vpc)
      Tags tags!(Name: stack_name!)
    end
  end
  resources.public_route do
    Type 'AWS::EC2::Route'
    Properties do
      GatewayId ref!(:gateway)
      RouteTableId ref!(:route_table)
      DestinationCidrBlock '0.0.0.0/0'
    end
  end
  resources.subnet do
    Type 'AWS::EC2::Subnet'
    Properties do
      CidrBlock ref!(:subnet_cidr)
      MapPublicIpOnLaunch true
      VpcId ref!(:vpc)
      Tags tags!(Name: stack_name!)
    end
  end
  resources.route_table_attachment do
    Type 'AWS::EC2::SubnetRouteTableAssociation'
    Properties do
      RouteTableId ref!(:route_table)
      SubnetId ref!(:subnet)
    end
  end
  resources.security_group do
    Type 'AWS::EC2::SecurityGroup'
    Properties do
      GroupDescription 'Allow SSH to packer builders'
      VpcId ref!(:vpc)
      Tags tags!(Name: stack_name!)
      SecurityGroupIngress do
        IpProtocol 'tcp'
        FromPort '22'
        ToPort '22'
        CidrIp '0.0.0.0/0'
      end
    end
  end

  resources.topic do
    Type 'AWS::SNS::Topic'
    Properties do
      DisplayName stack_name!
      TopicName build
    end
  end

  outputs.region do
    Description 'Region'
    Value region!
  end
  outputs.subnet_id do
    Description 'Subnet ID'
    Value ref!(:subnet)
  end
  outputs.security_group_id do
    Description 'Security Group ID'
    Value ref!(:security_group)
  end
end

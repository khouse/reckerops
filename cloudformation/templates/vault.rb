SparkleFormation.new(:vault) do
  resources.user do
    Type 'AWS::IAM::User'
    Properties do
      UserName join!(stack_name!, '-', region!)
      Policies [
        PolicyName: 'VaultRepoPolicy',
        PolicyDocument: {
          Version: '2012-10-17',
          Statement: [
            {
              Effect: 'Allow',
              Action: [
                'codecommit:BatchGetRepositories',
                'codecommit:Get*',
                'codecommit:List*',
                'codecommit:Put*',
                'codecommit:Test*',
                'codecommit:Update*',
                'codecommit:GitPull',
                'codecommit:GitPush'
              ],
              Resource: attr!(:repository, :arn),
            }
          ]
        }
      ]
    end
  end

  resources.topic do
    Type 'AWS::SNS::Topic'
    Properties do
      DisplayName stack_name!
      TopicName vault
    end
  end

  resources.repository do
    Type 'AWS::CodeCommit::Repository'
    Properties do
      RepositoryName 'vault'
      Triggers [
        Name: 'VaultNotifyChange',
        DestinationArn: ref!(:topic),
        Events: ['all'],
        Branches: ['Master']
      ]
    end
  end

  outputs.url do
    Description 'Clone URL'
    Value attr!(:repository, :clone_url_ssh)
  end
end

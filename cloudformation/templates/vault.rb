# frozen_string_literal: true

# rubocop:disable BlockLength
SparkleFormation.new(:vault) do
  dynamic!(
    :user, :user,
    user_name: join!(stack_name!, '-', region!),
    policy_name: 'VaultRepoPolicy', effect: 'Allow',
    resource: attr!(:repository, :arn),
    action: [
      'codecommit:BatchGetRepositories',
      'codecommit:Get*',
      'codecommit:List*',
      'codecommit:Put*',
      'codecommit:Test*',
      'codecommit:Update*',
      'codecommit:GitPull',
      'codecommit:GitPush'
    ]
  )
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

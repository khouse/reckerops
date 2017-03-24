# frozen_string_literal: true
SparkleFormation.dynamic(:user) do |name, config|
  resources(name) do
    Type 'AWS::IAM::User'
    Properties do
      UserName config.fetch(:user_name)
      Policies [
        PolicyName: config.fetch(:policy_name),
        PolicyDocument: {
          Version: '2012-10-17',
          Statement: [
            {
              Effect: config.fetch(:effect),
              Action: config.fetch(:action),
              Resource: config.fetch(:resource)
            }
          ]
        }
      ]
    end
  end
end

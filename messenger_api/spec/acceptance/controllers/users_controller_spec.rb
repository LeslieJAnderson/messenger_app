require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource 'User' do
  explanation "User endpoints."

  before(:each) do
    header 'Content-Type', 'application/json'
  end

  post '/user' do
    with_options scope: :user do
      parameter :username, 'Name that will appear in all messages', required: true
    end

    context '204' do

      let(:raw_post) do
        {
          user: {
            username: 'Louise'
          }
        }.to_json
      end

      example_request 'Create a User (204)' do

        expect(status).to eq(204)
        expect(User.all.size).to eq(1)
 
      end
    end

    context '422' do

      let(:raw_post) do
        {
          user: {
            unexpected_param: '12345'
          }
        }.to_json
      end

      example_request 'Create a User (422: Username Is Missing)' do

        expect(status).to eq(422)

        expect(User.all.size).to eq(0)
 
        expected_response = {
          # Weird that it's returning both but cutting this corner for time
          "errors" => { "username" => ["is too short (minimum is 3 characters)", "is too long (maximum is 16 characters)"] }
        }
 
        expect(JSON.parse(response_body)).to eq(expected_response)

      end
    end

    context '422' do

      before do

        FactoryBot.create(:louise)

      end

      let(:raw_post) do
        {
          user: {
            username: 'louise'
          }
        }.to_json
      end

      example_request 'Create a User (422: Username Already Taken)' do

        expect(status).to eq(422)

        expect(User.all.size).to eq(1)
 
        expected_response = {
          "errors" => { "username" => ["was already taken."] }
        }
 
        expect(JSON.parse(response_body)).to eq(expected_response)

      end
    end

  end
end
require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource 'Message' do
  explanation "Message endpoints."

  let (:gene)               { FactoryBot.create(:gene) }
  let (:louise)             { FactoryBot.create(:louise) }
  let (:tina)               { FactoryBot.create(:tina) }

  before(:each) do
    header 'Content-Type', 'application/json'
  end

  def boyz_4_now
    FactoryBot.create(:message, from_user_id: louise.id, to_user_id: tina.id, created_at: Time.now - 31.days, content: "THIS MESSAGE SHOULD NEVER APPEAR!")
    FactoryBot.create(:message, from_user_id: louise.id, to_user_id: tina.id, created_at: Time.now - 27.days, content: "Tina, Boyz 4 Now is your thing. I could care less.")
    FactoryBot.create(:message, from_user_id: tina.id, to_user_id: louise.id, created_at: Time.now - 26.days, content: "But remember when we went to the concert and you kind of lost your mind?")
    FactoryBot.create(:message, from_user_id: louise.id, to_user_id: tina.id, created_at: Time.now - 23.days, content: "Listen, some freak thing happened to me at that concert, but then I slapped Boo Boo's face and now I'm cured. Slap therapy, Tina. Ask your doctor.")
  end

  def excited
    FactoryBot.create(:message, from_user_id: tina.id, to_user_id: louise.id, created_at: Time.now - 31.days, content: "THIS MESSAGE SHOULD NEVER APPEAR!")
    FactoryBot.create(:message, from_user_id: tina.id, to_user_id: louise.id, created_at: Time.now - 26.days, content: "It's okay for you to be excited, Louise.")
    FactoryBot.create(:message, from_user_id: louise.id, to_user_id: tina.id, created_at: Time.now - 25.days, content: "Yeah, it's okay for you to be excited.")
    FactoryBot.create(:message, from_user_id: tina.id, to_user_id: louise.id, created_at: Time.now - 24.days, content: "Right. Listen, every day at around 2:30, my armpits get sweaty...")
    FactoryBot.create(:message, from_user_id: louise.id, to_user_id: tina.id, created_at: Time.now - 23.days, content: "Okay.")
    FactoryBot.create(:message, from_user_id: tina.id, to_user_id: louise.id, created_at: Time.now - 22.days, content: "And I used to hate raising my hand in class to answer a question, but one day, I had to say, who cares? I have swampy armpits and I'm gonna answer all the questions I want. I'm swampy and I'm proud.")
    FactoryBot.create(:message, from_user_id: louise.id, to_user_id: tina.id, created_at: Time.now - 21.days, content: "Tina, where are you going with this?")
    FactoryBot.create(:message, from_user_id: tina.id, to_user_id: louise.id, created_at: Time.now - 20.days, content: "I'm saying just because you think something is embarrassing doesn't mean you have to be embarrassed by it. We all have our swampy pits. My swampy pits is swampy pits. Maybe your swampy pits is Boo Boo.")
  end

  post '/message' do
    with_options scope: :message do
      parameter :from_username, "The sender's username.", required: true
      parameter :to_username, "The recipient's username.", required: true
      parameter :content, 'The message you want to send.', required: true
    end

    context '204' do

      let(:raw_post) do
        {
          message: {
            from_username: louise.username,
            to_username: tina.username,
            content: 'Tina, Boyz 4 Now is your thing. I could care less.'
          }
        }.to_json
      end

      example_request 'Create a Message (204)' do

        expect(status).to eq(204)
        expect(Message.all.size).to eq(1)
 
      end
    end

    context '422' do

      let(:raw_post) do
        {
          message: {
            from_username: louise.username,
            to_username: tina.username,
            content: ''
          }
        }.to_json
      end

      example_request 'Create a Message (422: Content Is Too Short)' do

        expect(status).to eq(422)
        expect(Message.all.size).to eq(0)

        expected_response = {
          "errors" => { "content" => ["is too short (minimum is 1 character)"] }
        }

        expect(JSON.parse(response_body)).to eq(expected_response)
 
      end
    end

    context '422' do

      let(:raw_post) do
        {
          message: {
            from_username: 'marshmellow',
            to_username: tina.username,
            content: ''
          }
        }.to_json
      end

      example_request 'Create a Message (422: Sender DNE)' do

        expect(status).to eq(422)
        expect(Message.all.size).to eq(0)

        expected_response = {
          "errors" => { "from_username" => ["Sender does not exist."] }
        }

        expect(JSON.parse(response_body)).to eq(expected_response)
 
      end
    end

    context '422' do

      let(:raw_post) do
        {
          message: {
            from_username: tina.username,
            to_username: 'marshmellow',
            content: ''
          }
        }.to_json
      end

      example_request 'Create a Message (422: Recipient DNE)' do

        expect(status).to eq(422)
        expect(Message.all.size).to eq(0)

        expected_response = {
          "errors" => { "to_username" => ["Recipient does not exist."] }
        }

        expect(JSON.parse(response_body)).to eq(expected_response)
 
      end
    end

  end

  get '/message/recent/:num_days/days/from/everyone' do
    before { boyz_4_now }

    context '200' do

      let(:num_days) { 30 }

      example_request "Show Recent Messages From Everyone By Days (200: Last 30 Days)" do
        expect(status).to eq(200)

        res = {}
        res = JSON.parse(response_body)
        expect(res["data"].size).to eq(3)
        expect(res["data"].first["attributes"]["content"]).to eq("Tina, Boyz 4 Now is your thing. I could care less.")
        expect(res["data"].last["attributes"]["content"]).to eq("Listen, some freak thing happened to me at that concert, but then I slapped Boo Boo's face and now I'm cured. Slap therapy, Tina. Ask your doctor.")
      end
    end

    context '422' do

      let(:num_days) { 31 }

      example_request "Show Recent Messages From Everyone By Days (422: Last 31 Days)" do
        expect(status).to eq(422)
        
        expected_response = {
          "errors" => { "num_days" => ["Cannot request messages created more than 30 days ago."] }
        }

        expect(JSON.parse(response_body)).to eq(expected_response)
      end
    end
  end

  get '/message/recent/:num_messages/messages/from/everyone' do
    before { excited }

    context '200' do

      let(:num_messages) { 7 }

      example_request "Show Recent Messages From Everyone By Amount (200: Last 7 Messages)" do
        expect(status).to eq(200)
        
        res = {}
        res = JSON.parse(response_body)
        expect(res["data"].size).to eq(7)
        expect(res["data"].first["attributes"]["content"]).to eq("It's okay for you to be excited, Louise.")
        expect(res["data"].last["attributes"]["content"]).to eq("I'm saying just because you think something is embarrassing doesn't mean you have to be embarrassed by it. We all have our swampy pits. My swampy pits is swampy pits. Maybe your swampy pits is Boo Boo.")
      end
    end

    context '422' do

      let(:num_messages) { 101 }

      example_request "Show Recent Messages From Everyone By Amount (422: Too Many Messages)" do
        expect(status).to eq(422)

        expected_response = {
          "errors" => { "num_messages" => ["Cannot request more than 100 messages."] }
        }

        expect(JSON.parse(response_body)).to eq(expected_response)
      end
    end
  end


  get '/message/recent/:num_days/days/from/louise/to/tina' do
    before { boyz_4_now }

    context '200' do

      let(:num_days) { 30 }

      example_request "Show Recent Messages From Someone By Days (200: Last 30 Days)" do

        expect(status).to eq(200)

        res = {}
        res = JSON.parse(response_body)
        expect(res["data"].size).to eq(2)
        expect(res["data"].first["attributes"]["content"]).to eq("Tina, Boyz 4 Now is your thing. I could care less.")
        expect(res["data"].last["attributes"]["content"]).to eq("Listen, some freak thing happened to me at that concert, but then I slapped Boo Boo's face and now I'm cured. Slap therapy, Tina. Ask your doctor.")

      end
    end

    context '422' do

      let(:num_days) { 31 }

      example_request "Show Recent Messages From Someone By Days (422: Last 31 Days)" do
        expect(status).to eq(422)
        expected_response = {
          "errors" => { "num_days" => ["Cannot request messages created more than 30 days ago."] }
        }

        expect(JSON.parse(response_body)).to eq(expected_response)
 
      end
    end
  end

  get '/message/recent/:num_messages/messages/from/tina/to/louise' do
    before { excited }

    context '200' do

      let(:num_messages) { 4 }

      example_request "Show Recent Messages From Someone By Amount (200: Last 4 Messages)" do

        expect(status).to eq(200)
        res = {}
        res = JSON.parse(response_body)
        expect(res["data"].size).to eq(4)
        expect(res["data"].first["attributes"]["content"]).to eq("It's okay for you to be excited, Louise.")
        expect(res["data"].last["attributes"]["content"]).to eq("I'm saying just because you think something is embarrassing doesn't mean you have to be embarrassed by it. We all have our swampy pits. My swampy pits is swampy pits. Maybe your swampy pits is Boo Boo.")

 
      end
    end

    context '422' do

      let(:num_messages) { 101 }

      example_request "Show Recent Messages From Someone By Amount (422: Too Many Messages)" do

        expect(status).to eq(422)
        expected_response = {
          "errors" => { "num_messages" => ["Cannot request more than 100 messages."] }
        }

        expect(JSON.parse(response_body)).to eq(expected_response)
 
      end
    end
  end
end
require 'rails_helper'

RSpec.describe Message, type: :model do

  describe 'create' do

    let (:gene)               { FactoryBot.create(:gene) }
    let (:louise)             { FactoryBot.create(:louise) }
    let (:tina)               { FactoryBot.create(:tina) }

    let (:string_length_1000) { 'a' * 1000 }
    let (:string_length_1001) { 'a' * 1001 }

    it 'should guarantee users are set' do

      FactoryBot.create(:message, from_user_id: gene.id, to_user_id: louise.id, content: 'Testing nil users')

      expect {
        FactoryBot.create(:message, from_user_id: gene.id, to_user_id: nil, content: 'Testing nil users')
      }.to raise_exception(ActiveRecord::RecordInvalid, "Validation failed: To user must exist")

      expect {
        FactoryBot.create(:message, from_user_id: nil, to_user_id: gene.id, content: 'Testing nil users')
      }.to raise_exception(ActiveRecord::RecordInvalid, "Validation failed: From user must exist")

      expect {
        FactoryBot.create(:message, from_user_id: gene.id, to_user_id: 999_999_999, content: 'Testing nil users')
      }.to raise_exception(ActiveRecord::RecordInvalid, "Validation failed: To user must exist")

      expect {
        FactoryBot.create(:message, from_user_id: 999_999_999, to_user_id: gene.id, content: 'Testing nil users')
      }.to raise_exception(ActiveRecord::RecordInvalid, "Validation failed: From user must exist")

    end

    it 'should guarantee content length' do

      expect {
        FactoryBot.create(:message, to_user_id: louise.id, from_user_id: tina.id, content: '')
      }.to raise_exception(ActiveRecord::RecordInvalid, 'Validation failed: Content is too short (minimum is 1 character)')

      FactoryBot.create(:message, to_user_id: louise.id, from_user_id: tina.id, content: '1')
      FactoryBot.create(:message, to_user_id: louise.id, from_user_id: tina.id, content: string_length_1000)

      expect {
        FactoryBot.create(:message, to_user_id: louise.id, from_user_id: tina.id, content: string_length_1001)
      }.to raise_exception(ActiveRecord::RecordInvalid, 'Validation failed: Content is too long (maximum is 1000 characters)')

    end

  end

end

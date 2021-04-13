require 'rails_helper'

RSpec.describe User, type: :model do

  describe 'create' do

    let (:string_length_2)  { 'a' * 2 }
    let (:string_length_3)  { 'a' * 3 }
    let (:string_length_16) { 'a' * 16 }
    let (:string_length_17) { 'a' * 17 }

    it 'should guarantee username is appropriate length' do

      expect {
        FactoryBot.create(:user, username: '')
      }.to raise_exception(ActiveRecord::RecordInvalid, 'Validation failed: Username is too short (minimum is 3 characters)')

      expect {
        FactoryBot.create(:user, username: string_length_2)
      }.to raise_exception(ActiveRecord::RecordInvalid, 'Validation failed: Username is too short (minimum is 3 characters)')

      FactoryBot.create(:user, username: string_length_3)

      FactoryBot.create(:user, username: string_length_16)

      expect {
        FactoryBot.create(:user, username: string_length_17)
      }.to raise_exception(ActiveRecord::RecordInvalid, 'Validation failed: Username is too long (maximum is 16 characters)')

    end

    it 'should guarantee username is unique' do

      FactoryBot.create(:louise)

      expect {
        FactoryBot.create(:louise)
      }.to raise_exception(ActiveRecord::RecordInvalid, 'Validation failed: Username was already taken.')

      expect {
        FactoryBot.create(:user, username: 'LOUISE')
      }.to raise_exception(ActiveRecord::RecordInvalid, 'Validation failed: Username was already taken.')

    end
  end

  describe 'destroy' do
    let (:tina) { FactoryBot.create(:tina) }
    let (:gene) { FactoryBot.create(:gene) }
    let (:louise) { FactoryBot.create(:louise) }

    it 'should destroy message' do
      FactoryBot.create(:message, from_user_id: louise.id, to_user_id: tina.id, created_at: Time.now - 27.days, content: "Tina, Boyz 4 Now is your thing. I could care less.")
      FactoryBot.create(:message, from_user_id: tina.id, to_user_id: louise.id, created_at: Time.now - 26.days, content: "But remember when we went to the concert and you kind of lost your mind?")
      FactoryBot.create(:message, from_user_id: gene.id, to_user_id: louise.id, created_at: Time.now - 26.days, content: "Uhhh, I was talking to the taco.")
      
      tina.destroy
      expect(Message.all.length).to eq(1)
    end
  end

end

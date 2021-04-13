FactoryBot.define do
  factory :user do
    username { 'the_user' }
  end

  factory :gene, parent: :user do
    username { 'gene' }
  end

  factory :louise, parent: :user do
    username { 'louise' }
  end

  factory :tina, parent: :user do
    username { 'tina' }
  end

end

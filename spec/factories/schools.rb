FactoryGirl.define do

  factory :school do
  end

  factory :healey, class: School do
    state_id 15
    slug 'hea'
    local_id "HEA"
  end

  factory :brown, class: School do
    state_id 75
    slug 'brn'
    local_id "BRN"
  end

  trait :with_educator do
    after(:create) do |school|
      school.educators << FactoryGirl.create(:educator, full_name: 'Stephenson, Neal')
    end
  end

end

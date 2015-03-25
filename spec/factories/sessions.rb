FactoryGirl.define do
  sequence(:identifier) { |n| "bigheart-#{n}" }
  factory :session do
    identifier
    completed_to { 1.days.ago }
    sources(SOURCES)
  end
end

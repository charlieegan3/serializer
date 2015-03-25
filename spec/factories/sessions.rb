FactoryGirl.define do
  factory :session do
    identifier 'bigheart'
    completed_to { 1.days.ago }
    sources(SOURCES)
  end
end

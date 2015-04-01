FactoryGirl.define do
  sequence(:url) { |n| "http://www.serializer.io/#{n}" }
  factory :item do
    title 'Awesome News Site'
    url
    source 'hacker_news'
    topped true
    comment_url 'http://www.serializer.io/comments'
    redirect_url 'http://www.serializer.io/welcome'
    tweet_count 100
    word_count 500
    created_at Time.zone.now
    updated_at Time.zone.now
  end
end

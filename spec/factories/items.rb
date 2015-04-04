FactoryGirl.define do
  sequence(:url) { |n| "http://www.serializer.io/#{n}" }
  sequence(:redirect_url) { |n| "http://www.cool_linkz.com/#{n}" }
  sequence(:title) { |n| "Article #{n}" }
  factory :item do
    title
    url
    source 'hacker_news'
    topped true
    comment_url 'http://www.serializer.io/comments'
    redirect_url
    tweet_count 100
    word_count 500
    created_at Time.zone.now
    updated_at Time.zone.now
  end
end

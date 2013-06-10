# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :page do
    title "MyString"
    slug "MyString"
    body "MyText"
    user nil
  end
end

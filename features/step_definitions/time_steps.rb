Given /^today is (.+)$/ do |date|
  travel_to Date.parse date
end

Given /^I am using cassettes from (.+)$/ do |date|
  travel_to Date.parse date
end

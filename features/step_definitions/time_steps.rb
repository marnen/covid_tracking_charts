Given /^today is (.+)$/ do |date|
  travel_to Date.parse date
end

When /^I visit (.+)$/ do |page_name|
  visit path_to page_name
end

Then /^I should see data for (.+) on (.+)$/ do |state, date|
  expect(page).to have_text "https://covidtracking.com/api/states/daily?state=#{state.upcase}&date=#{Date.parse(date).to_s :number}"
end

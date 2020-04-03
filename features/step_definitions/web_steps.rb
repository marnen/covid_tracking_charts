When /^I visit (.+)$/ do |page_name|
  visit path_to page_name
end

Then /^I should see data for (.+) on (.+)$/ do |state, date|
  date = Date.parse(date).to_s :number
  expect(page).to have_text %r{#{Regexp.escape %Q({"date":#{date},"state":"#{state.upcase}")}.*\}}
end

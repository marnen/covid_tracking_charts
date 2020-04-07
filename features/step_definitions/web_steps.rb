Given /^I am on (.+)$/ do |page_name|
  visit path_to page_name
end

When 'I click {string}' do |string|
  click_on string
end

When 'I click on the header' do
  find('header a').click
end

When 'I select {string} from the state menu' do |state|
  select state, from: 'State'
end

When /^I visit (.+)$/ do |page_name|
  visit path_to page_name
end

Then /^I should be on (.+)$/ do |page_name|
  expect(current_path).to be == path_to(page_name)
end

Then /^I should see a graph for (.+?) for the (\d+) day(?:s)? ending on (.+?)$/ do |state, days, end_date|
  state = State.find state
  end_date = Date.parse(end_date)
  start_date = end_date - (days.to_i.pred).days
  date_range = start_date..end_date

  page.find 'svg' do |svg|
    expect(svg).to have_selector '.keyText', text: state.name
    expect(svg).to have_xpath '//text[@class="dataPointPopup"][1]', text: /^#{start_date.strftime '%d %b %Y'},/
    expect(svg).to have_xpath '//text[@class="dataPointPopup"][last()]', text:/^#{end_date.strftime '%d %b %Y'},/
  end
end

Then '{string} should be selected in the state menu' do |state|
  expect(find_field('State', type: :select)).to have_css 'option[selected]', text: state
end

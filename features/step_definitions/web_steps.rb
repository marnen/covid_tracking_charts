Given /^I am on (.+)$/ do |page_name|
  visit path_to page_name
end

When 'I click {string}' do |string|
  click_on string
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

  page.find 'img[src^="https://image-charts.com/chart?"]' do |img|
    params = Hash[URI.decode_www_form URI(img['src']).query]
    expect(params).to include(
      'cht' => 'lc', # line chart
      'chd' => a_string_starting_with('a:'), # data
      'chxt' => 'x,y', # axes
      'chxl' => "0:|#{start_date.to_s :short}|#{end_date.to_s :short}" ,# axis labels
      'chdl' => state.name, # legend
      'chls' => '3' # line thickness
    )
    expect(params['chd'].match(/^a:(.+)$/)[1].split(',').count).to be == days
  end
end

Then '{string} should be selected in the state menu' do |state|
  expect(find_field('State', type: :select)).to have_css 'option[selected]', text: state
end

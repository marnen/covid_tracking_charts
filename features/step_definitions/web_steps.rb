Given /^I am on (.+)$/ do |page_name|
  visit path_to page_name
end

When 'I click {string}' do |string|
  click_on string
end

When 'I click on the header' do
  find('header a').click
end

When /^I (de)?select "(.+)" from the state menu$/ do |deselect, state|
  method = deselect ? :unselect : :select
  public_send method, state, from: 'State'
end

When /^I visit (.+)$/ do |page_name|
  visit path_to page_name
end

Then /^I should be on (.+)$/ do |page_name|
  expect(current_path).to be == path_to(page_name)
end

Then /^I should see a graph for (.+?) for the (\d+) day(?:s)? ending on (.+?)$/ do |states, days, end_date|
  states = State.find states.strip.split(%r{\W+})
  end_date = Date.parse(end_date)
  start_date = end_date - (days.to_i.pred).days
  date_range = start_date..end_date

  page.find 'svg' do |svg|
    states.each do |state|
      expect(svg).to have_css '.keyText', text: state.name
    end
    expect(svg).to have_css '.dataPointLabel', count: states.count * days
    [start_date, end_date].each do |date|
      expect(svg).to have_css '.dataPointPopup', text: /^#{date.strftime '%d %b %Y'},/, count: states.count, visible: :all
    end
  end
end

Then '{string} should be selected in the state menu' do |state|
  expect(find_field('State', type: :select)).to have_css 'option[selected]', text: state
end

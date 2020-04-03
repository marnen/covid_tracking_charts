When /^I visit (.+)$/ do |page_name|
  visit path_to page_name
end

Then /^I should see data for (.+?) for the (\d+) day(?:s)? ending on (.+?)$/ do |state, days, end_date|
  end_date = Date.parse(end_date)
  date_range = (end_date - (days.to_i.pred).days)..end_date

  date_range.each do |date|
    expect(page).to have_text %r{#{Regexp.escape %Q({"date"=>#{date.to_s :number}, "state"=>"#{state.upcase}")}.*?\}}
  end
end

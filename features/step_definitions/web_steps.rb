When /^I visit (.+)$/ do |page_name|
  visit path_to page_name
end

Then /^I should see a graph for (.+?) for the (\d+) day(?:s)? ending on (.+?)$/ do |state, days, end_date|
  end_date = Date.parse(end_date)
  start_date = end_date - (days.to_i.pred).days
  date_range = start_date..end_date

  page.find 'img[src^="https://image-charts.com/chart?"]' do |img|
    params = Faraday::Utils.parse_query URI(img['src']).query
    expect(params).to include(
      'cht' => 'lc', # line chart
      'chd' => a_string_starting_with('a:'), # data
      'chxt' => 'x,y', # axes
      'chxl' => "0:|#{start_date.to_s :short}|#{end_date.to_s :short}" ,# axis labels
      'chls' => '3' # line thickness
    )
    expect(params['chd'].match(/^a:(.+)$/)[1].split(',').count).to be == days
  end
  #
  # date_range.each do |date|
  #   expect(page).to have_text %r{#{Regexp.escape %Q({"date"=>#{date.to_s :number}, "state"=>"#{state.upcase}")}.*?\}}
  # end
end

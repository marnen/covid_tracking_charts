VCR.configure do |c|
  c.hook_into :webmock
  c.cassette_library_dir = File.join(Rails.root, 'features', 'cassettes')
  c.default_cassette_options = {
    :match_requests_on => [:method, :host, :path]
  }
end

VCR.cucumber_tags do |t|
  t.tag  '@vcr', use_scenario_name: true
end

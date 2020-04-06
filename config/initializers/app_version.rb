File.open File.join(Rails.root, 'CHANGELOG.md'), 'r' do |changelog|
  line = changelog.gets until line.to_s.strip =~ %r{^# v(\d\S*) / (\S+)}
  APP_VERSION = $1
  RELEASE_DATE = Date.parse $2
end

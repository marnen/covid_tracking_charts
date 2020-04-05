module PathHelpers
  def path_to(page_name)
    case page_name
    when /^the page for (.+)$/
      state_path $1.downcase
    else
      begin
        path_helper = page_name.gsub(/\bpage$/, 'path').gsub(/^the /, '').gsub(' ', '_')
        self.send path_helper
      rescue NoMethodError
        raise ArgumentError, "Path to #{page_name.inspect} is not defined. Please add a mapping in #{__FILE__}."
      end
    end
  end
end

World PathHelpers

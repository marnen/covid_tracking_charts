require 'rails_helper'

RSpec.describe Time, type: :model do
  describe '.zone' do
    it 'is set to Eastern Time' do
      expect(Time.zone.name).to be == 'Eastern Time (US & Canada)'
    end
  end
end

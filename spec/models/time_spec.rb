require 'rails_helper'

RSpec.describe Time, type: :model do
  describe '.zone' do
    it 'is set to Pacific Time' do
      expect(Time.zone.name).to be == 'Pacific Time (US & Canada)'
    end
  end
end

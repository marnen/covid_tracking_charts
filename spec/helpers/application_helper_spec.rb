require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe '#states' do
    it 'returns all the states' do
      expect(helper.states).to be == State.all
    end
  end
end

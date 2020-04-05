require 'rails_helper'

RSpec.describe State, type: :model do
  describe 'constructor' do
    it 'is not accessible' do
      expect { described_class.new abbr: 'FR', name: 'Franklin' }.to raise_error NoMethodError
    end
  end

  describe '.find' do
    context 'valid state abbreviation' do
      let(:state_abbr) { Faker::Address.state_abbr }
      let(:state_name) { CS.states(:us)[state_abbr.upcase.to_sym] }

      it 'returns the appropriate state regardless of case' do
        [:upcase, :downcase].each do |transformation|
          transformed_abbr = state_abbr.public_send transformation
          state = described_class.find transformed_abbr
          expect(state).to be_a_kind_of described_class
          expect(state.name).to be == state_name
          expect(state.abbr).to be == state_abbr
        end
      end

      it 'handles symbols like strings' do
        [:upcase, :downcase].each do |transformation|
          transformed_abbr = state_abbr.public_send(transformation).to_sym
          state = described_class.find transformed_abbr
          expect(state).to be_a_kind_of described_class
          expect(state.name).to be == state_name
          expect(state.abbr).to be == state_abbr
        end
      end
    end

    context 'invalid state abbreviation' do
      subject { described_class.find 'XT' }

      it { is_expected.to be_nil }
    end
  end

  describe '#abbr' do
    it 'returns the abbreviation' do
      expect(described_class.find('ny').abbr).to be == 'NY'
    end
  end

  describe '#name' do
    it 'returns the name' do
      expect(described_class.find('pa').name).to be == 'Pennsylvania'
    end
  end
end

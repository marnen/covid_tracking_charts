require 'rails_helper'

RSpec.describe State, type: :model do
  describe 'constructor' do
    it 'is not accessible' do
      expect { described_class.new abbr: 'FR', name: 'Franklin' }.to raise_error NoMethodError
    end
  end

  describe '.all' do
    subject { described_class.all }

    it 'returns all the states' do
      expect(subject).to all be_a_kind_of State
      expect(subject.map {|state| [state.abbr, state.name] }).to match_array CS.states(:us).map {|abbr, name| [abbr.to_s, name] }
    end
  end

  describe '.find' do
    context 'scalar' do
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

    context 'array' do
      subject { described_class.find state_abbrs }

      context 'valid state abbreviations' do
        let(:state_abbrs) { Array.new(rand 2..5) { Faker::Address.state_abbr } }

        it 'returns the state for each abbreviation' do
          expect(subject).to be == state_abbrs.map {|abbr| described_class.find abbr }
        end
      end

      context 'some invalid state abbreviations' do
        let(:state_abbrs) { [Faker::Address.state_abbr, 'ZY', Faker::Address.state_abbr] }

        it 'returns only the states for the valid abbreviations' do
          expect(subject).to be == [described_class.find(state_abbrs.first), described_class.find(state_abbrs.last)]
        end
      end
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

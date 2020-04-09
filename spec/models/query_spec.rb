require 'rails_helper'

RSpec.describe Query, type: :model do
  let(:states) { State.all.sample(rand 2..5) }
  let(:end_date) { rand(1..10).days.ago }
  let(:start_date) { end_date - rand(10..30).days }
  let(:date_range) { start_date..end_date }
  let(:params) { {states: states, date_range: date_range} }

  subject { described_class.new params }

  describe 'constructor' do
    it 'takes a list of states and a date range' do
      expect(subject).to be_a_kind_of described_class
    end
  end

  context 'instance methods' do
    describe '#client' do
      subject { super().client }

      context 'default' do
        it { is_expected.to be StateDaily }
      end

      context 'client given' do
        let(:client) { Class.new }
        let(:params) { super().merge client: client }

        it 'returns the given class' do
          expect(subject).to be client
        end
      end
    end

    describe '#raw_data' do
      let(:client) do
        Class.new do
          def initialize(state:, date:)
            @state = state
            @date = date
          end

          def fetch!
            "Data for #{@state.name}, #{@date}"
          end
        end
      end
      let(:params) { super().merge client: client }

      subject { super().raw_data }

      it "returns a hash with each state's data fetched from the client for the given date range" do
        expect(subject).to be == states.to_h {|state| [state, client.new(state: state, date: date_range).fetch!] }
      end
    end
  end
end

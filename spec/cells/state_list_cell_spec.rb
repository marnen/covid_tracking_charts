require 'rails_helper'

RSpec.describe StateListCell, type: :cell do
  let(:states) { State.all.sample rand(2..5) }
  subject { described_class.new states }

  describe 'constructor' do
    it { is_expected.to be_a_kind_of Cell::ViewModel }
    it { is_expected.to be_a_kind_of ERB::Util }
  end

  describe '#show' do
    subject { Capybara.string cell(described_class, states).call }

    it 'returns a string of the form "Data for state1 (S1), state2 (S2), ..."' do
      expect(subject.text.chomp).to be == "Data for #{states.map {|state| "#{state.name} (#{state.abbr})" }.join ', ' }"
    end

    it 'wraps each state name in a span of class "state-n"' do
      states.each.with_index(1) do |state, index|
        expect(subject).to have_selector "span.state-#{index}", text: state.name
      end
    end
  end
end

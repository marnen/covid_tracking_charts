require 'rails_helper'

RSpec.describe StateSelectorCell, type: :cell do
  let(:states) { [] }
  let(:url) { nil }
  let(:options) { {url: url} }

  subject { described_class.new states, options }

  context 'constructor' do
    it { is_expected.to be_a_kind_of Cell::ViewModel }

    it 'includes form helpers' do
      ['FormHelper', 'FormOptionsHelper'].each do |helper|
        expect(subject).to be_a_kind_of "ActionView::Helpers::#{helper}".constantize
      end
    end
  end

  context '#show' do
    controller Class.new(ApplicationController) # see https://github.com/trailblazer/rspec-cells#url-helpers

    let(:url) { File.join *Faker::Lorem.words(rand 2..5) }
    let(:menu) { 'select[multiple][name="states[]"]' }

    subject { Capybara.string cell(described_class, states, options).call }

    it 'renders a form that will submit to the given URL' do
      expect(subject).to have_selector "form[action='#{url}']"
    end

    it 'renders a multi-select with all the states as options, sorted by name' do
      subject.find menu do |menu|
        selector = './/' + State.all.sort_by(&:name).map {|state| "option[@value='#{state.abbr}'][text()='#{state.name}']"}.join('/following-sibling::')
        expect(menu).to have_xpath selector
      end
    end

    context 'states given' do
      let(:states) { State.all.sample rand(2..5) }

      it 'marks all the states given as selected' do
        subject.find(menu) do |menu|
          expect(menu.all('option[selected]').map &:text).to match_array states.map(&:name)
        end
       end
    end

    context 'no states given' do
      it 'marks no states as selected' do
        expect(subject.find menu).not_to have_css 'option[selected]'
      end
    end
  end
end

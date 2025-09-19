# frozen_string_literal: true

require 'catalogue'

RSpec.describe Catalogue do
  let(:catalogue) { described_class.new({ A: 100, 'B' => 200 }) }

  describe '#[]' do
    it 'fetches product price by string or symbol' do
      expect(catalogue['A']).to eq(100)
      expect(catalogue[:B]).to eq(200)
    end

    it 'raises for unknown product' do
      expect { catalogue['Z'] }.to raise_error(KeyError, /Unknown product/)
    end
  end

  describe '#include?' do
    it 'returns true for known product' do
      expect(catalogue.include?('A')).to be(true)
      expect(catalogue.include?(:B)).to be(true)
    end

    it 'returns false for unknown product' do
      expect(catalogue.include?('Z')).to be(false)
    end
  end
end

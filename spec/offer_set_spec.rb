# frozen_string_literal: true

require 'offer_set'

RSpec.describe OfferSet do
  let(:offer_1) { ->(tally, _) { tally['A']&.positive? ? 100 : 0 } }
  let(:offer_2) { ->(tally, _) { tally['B']&.positive? ? 50.4 : 0 } }

  subject(:offer_set) { described_class.new([offer_1, offer_2]) }

  let(:catalogue) { { 'A' => 200, 'B' => 300 } }

  describe '#call' do
    it 'sums discounts from all offers and rounds up' do
      tally = { 'A' => 2, 'B' => 1 }
      expect(offer_set.call(tally, catalogue)).to eq(151) # 100 + 50.4 → ceil = 151
    end

    it 'returns 0 when no offers apply' do
      tally = {}
      expect(offer_set.call(tally, catalogue)).to eq(0)
    end
  end
end

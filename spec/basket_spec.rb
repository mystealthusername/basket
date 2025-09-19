# frozen_string_literal: true

require 'basket'
require 'catalogue'
require 'delivery_rule_set'
require 'offer_set'

RSpec.describe Basket do
  let(:catalogue) { Catalogue.new({ 'A' => 1000, 'B' => 2000 }) } # in cents
  let(:delivery_rule_set) do
    DeliveryRuleSet.new(
      [
        DeliveryRule.new(0..2999, 495),
        DeliveryRule.new(3000..Float::INFINITY, 0)
      ]
    )
  end
  let(:offer_set) do
    OfferSet.new(
      ->(tally, _) { tally['A'].to_i >= 2 ? 500 : 0 }
    )
  end

  subject(:basket) { described_class.new(catalogue:, delivery_rule_set:, offer_set:) }

  describe '#add' do
    it 'raises when product is not in catalogue' do
      expect { basket.add('Z') }.to raise_error(KeyError, /Unknown product/)
    end
  end

  describe '#total' do
    it 'calculates subtotal + delivery - discounts' do
      basket.add('A')
      basket.add(:B)
      # subtotal = 1000 + 2000 = 3000
      # discount = 0 (not enough A’s)
      # delivery = 0 (>= 3000)
      expect(basket.total).to eq(3000)
    end

    it 'applies offers when eligible' do
      2.times { basket.add('A') }
      # subtotal = 2000
      # discount = 500
      # delivery = 495 (total after discount = 1500)
      expect(basket.total).to eq(2000 - 500 + 495)
    end
  end

  describe '#formatted_total' do
    it 'returns formatted total in dollars' do
      basket.add('A')
      expect(basket.formatted_total).to eq('$14.95') # 1000 + 495 = 1495 → $14.95
    end
  end
end
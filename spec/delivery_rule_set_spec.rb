# frozen_string_literal: true

require 'delivery_rule'
require 'delivery_rule_set'

RSpec.describe DeliveryRuleSet do
  let(:rules) do
    [
      DeliveryRule.new(0..4999, 495),
      DeliveryRule.new(5000..Float::INFINITY, 0)
    ]
  end

  subject(:rule_set) { described_class.new(rules) }

  describe '#cost_for' do
    it 'returns the cost for a total within range' do
      expect(rule_set.cost_for(3000)).to eq(495)
      expect(rule_set.cost_for(5000)).to eq(0)
    end

    it 'raises if no rule covers the total' do
      bad_rule_set = described_class.new([DeliveryRule.new(0..1000, 123)])
      expect { bad_rule_set.cost_for(2000) }.to raise_error('No delivery rule found')
    end
  end
end

# frozen_string_literal: true

class DeliveryRuleSet
  def initialize(rules)
    @rules = Array(rules).freeze
  end

  def cost_for(total)
    rule = rules.find { |r| r.range.include?(total) }
    raise 'No delivery rule found' unless rule

    rule.cost
  end

  private

  attr_reader :rules
end

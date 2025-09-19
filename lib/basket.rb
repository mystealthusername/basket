# frozen_string_literal: true

require_relative 'catalogue'
require_relative 'delivery_rule_set'
require_relative 'offer_set'

class Basket
  def initialize(catalogue:, delivery_rule_set:, offer_set:)
    @items = []
    @catalogue = catalogue
    @delivery_rule_set = delivery_rule_set
    @offer_set = offer_set
  end

  def add(product_id)
    raise KeyError, "Unknown product: #{product_id}" unless catalogue.include?(product_id)

    @items << product_id.to_s
  end

  # Returns total in cents
  def total
    discounted = subtotal - discount
    (discounted + delivery_cost(discounted))
  end

  def formatted_total
    format('$%.2f', (total / 100.0))
  end

  private

  attr_reader :catalogue, :delivery_rule_set, :offer_set, :items

  def subtotal
    items.sum { |code| catalogue[code] }
  end

  def discount
    offer_set.call(items.tally, catalogue)
  end

  def delivery_cost(discounted_total)
    delivery_rule_set.cost_for(discounted_total)
  end
end

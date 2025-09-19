require_relative 'catalogue'
require_relative 'delivery_rule'
require_relative 'delivery_rule_set'
require_relative 'offer_set'
require_relative 'basket'

catalogue = Catalogue.new({
  "R01" => 3295,
  "G01" => 2495,
  "B01" => 795
})

delivery_rule_set = DeliveryRuleSet.new([
  DeliveryRule.new(0..4_999, 495),
  DeliveryRule.new(5_000..8_999, 295),
  DeliveryRule.new(9_000..Float::INFINITY, 0)
])

red_widget_offer = lambda do |items, catalogue|
  count = items.fetch("R01", 0)
  discount_pairs = count / 2
  discount_pairs * (catalogue["R01"] / 2.0)
end

offer_set = OfferSet.new(red_widget_offer)

# --- EXAMPLES ---

basket = Basket.new(catalogue:, delivery_rule_set:, offer_set:)
basket.add("B01")
basket.add("G01")
puts "Example 1: #{basket.formatted_total}"  # 37.85

basket = Basket.new(catalogue:, delivery_rule_set:, offer_set:)
basket.add("R01")
basket.add("R01")
puts "Example 2: #{basket.formatted_total}"  # 54.37

basket = Basket.new(catalogue:, delivery_rule_set:, offer_set:)
basket.add("R01")
basket.add("G01")
puts "Example 3: #{basket.formatted_total}"  # 60.85

basket = Basket.new(catalogue:, delivery_rule_set:, offer_set:)
basket.add("B01")
basket.add("B01")
basket.add("R01")
basket.add("R01")
basket.add("R01")
puts "Example 4: #{basket.formatted_total}"  # 98.27

# Basket

A Ruby shopping basket application that calculates totals with support for product catalogues, delivery rules, and promotional offers.

## Features

- **Product Catalogue**: Manage a collection of products with their prices
- **Shopping Basket**: Add products and calculate totals
- **Delivery Rules**: Configurable delivery costs based on order value
- **Promotional Offers**: Apply discounts based on product combinations
- **Price Formatting**: Display totals in a user-friendly format

## Installation

1. Clone the repository:
```bash
git clone https://github.com/mystealthusername/basket.git
cd basket
```

2. Install dependencies:
```bash
bundle install
```

## Usage

### Basic Example

```ruby
require_relative 'lib/basket'
require_relative 'lib/catalogue'
require_relative 'lib/delivery_rule_set'
require_relative 'lib/offer_set'

# Create a product catalogue (prices in cents)
catalogue = Catalogue.new({
  'A' => 1000,  # $10.00
  'B' => 2000,  # $20.00
  'C' => 1500   # $15.00
})

# Set up delivery rules
delivery_rules = DeliveryRuleSet.new([
  DeliveryRule.new(0..2999, 495),      # $4.95 delivery for orders under $30
  DeliveryRule.new(3000..Float::INFINITY, 0)  # Free delivery for orders $30+
])

# Set up promotional offers
offers = OfferSet.new([
  ->(tally, _) { tally['A'].to_i >= 2 ? 500 : 0 }  # $5 off when buying 2+ of product A
])

# Create and use the basket
basket = Basket.new(
  catalogue: catalogue,
  delivery_rule_set: delivery_rules,
  offer_set: offers
)

# Add products
basket.add('A')
basket.add('B')

# Get totals
puts basket.formatted_total  # => "$34.95"
puts basket.total           # => 3495 (in cents)
```

### Key Components

#### Catalogue
Manages a collection of products with their prices:
```ruby
catalogue = Catalogue.new({ 'A' => 1000, 'B' => 2000 })
catalogue['A']  # => 1000
catalogue.include?('A')  # => true
```

#### DeliveryRuleSet
Defines delivery costs based on order value:
```ruby
rules = DeliveryRuleSet.new([
  DeliveryRule.new(0..2999, 495),      # $4.95 for orders under $30
  DeliveryRule.new(3000..Float::INFINITY, 0)  # Free delivery for $30+
])
```

ATTENTION: This class does not validate whether all ranges are covered.

#### OfferSet
Applies promotional discounts:
```ruby
offers = OfferSet.new([
  lambda do |items, catalogue|
    count = items.fetch("R01", 0)
    discount_pairs = count / 2
    discount_pairs * (catalogue["R01"] / 2.0)
  end
])
```

Alternative approach for passing only one Offer:
```ruby
offers = OfferSet.new(
  lambda do |items, catalogue|
    count = items.fetch("R01", 0)
    discount_pairs = count / 2
    discount_pairs * (catalogue["R01"] / 2.0)
  end
)
```

#### Basket
The main shopping basket that combines all components:
```ruby
basket = Basket.new(
  catalogue: catalogue,
  delivery_rule_set: delivery_rules,
  offer_set: offers
)

basket.add('A')
basket.add('B')
basket.total           # Returns total in cents
basket.formatted_total # Returns formatted string like "$34.95"
```

## Testing

Run the test suite:
```bash
bundle exec rspec
```

## Architecture

The application follows a modular design with clear separation of concerns:

- **Basket**: Main orchestrator that coordinates between components
- **Catalogue**: Product and pricing management
- **DeliveryRuleSet**: Delivery cost calculation
- **OfferSet**: Promotional discount application

All prices are handled in cents to avoid floating-point precision issues, with formatting provided for display purposes.

## Requirements

- Ruby 3.2.2 (specified in `.tool-versions`)
- RSpec for testing

# frozen_string_literal: true

class Catalogue
  # Initialize a new Catalogue with a hash of products
  #
  # @param products [Hash] A hash where keys are product codes and values are product data
  # @return [Catalogue] A new Catalogue instance
  def initialize(products)
    @products = products.transform_keys(&:to_s).freeze
  end

  def [](code)
    products.fetch(code.to_s) { raise KeyError, "Unknown product: #{code}" }
  end

  def include?(code)
    products.key?(code.to_s)
  end

  private

  attr_reader :products
end

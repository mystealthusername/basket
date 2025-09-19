# frozen_string_literal: true

class OfferSet
  def initialize(offers)
    @offers = Array(offers).freeze
  end

  def call(tally, catalogue)
    offers.sum { |offer| offer.call(tally, catalogue) }.ceil
  end

  private

  attr_reader :offers
end

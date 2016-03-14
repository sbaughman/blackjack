require_relative 'card'

class Deck

  attr_accessor :cards

  def initialize
    self.cards = make_deck
    shuffle
  end

  def make_deck
    Card.suits.inject([]) do |arr, suit|
      arr + Card.faces.map { |face| Card.new(suit, face) }
    end
  end

  def shuffle
    cards.shuffle!
  end

  def empty?
    cards.empty?
  end

  def draw
    cards.shift
  end

end

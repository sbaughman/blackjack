class Card
  def self.suits
    %w(hearts diamonds clubs spades)
  end

  def self.faces
    %w(2 3 4 5 6 7 8 9 10 Jack Queen King Ace)
  end

  def self.values
    %w(2 3 4 5 6 7 8 9 10 10 10 10 11)
  end

  def self.blackjack_values
    Hash[faces.zip values]
  end

  attr_accessor :suit, :face, :value

  def initialize(suit, face)
    self.suit = suit
    self.face = face
    self.value = set_value
  end

  def set_value
    self.class.blackjack_values[face].to_i
  end
end

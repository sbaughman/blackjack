require_relative 'deck'

class Game

  attr_accessor :dealer_hand,
                :player_hand,
                :deck,
                :player_done

  def initialize
    self.deck = Deck.new
    self.dealer_hand = []
    self.player_hand = []
    self.player_done = false
  end

  def play
    deal
    until player_done || bust?(player_hand) || blackjack?
      player_choice
    end
    until get_value(dealer_hand) > 16 || bust?(dealer_hand) || blackjack?
      hit(dealer_hand)
    end
    output_results(winner)
  end

  def deal
    self.dealer_hand.push(deck.draw, deck.draw)
    self.player_hand.push(deck.draw, deck.draw)
    puts "\nDealer Hand:\n*********  face-down card\n#{dealer_hand[0].face} of #{dealer_hand[0].suit}, value #{get_value(dealer_hand[0])}.\n"
    puts "\nPlayer Hand: "
    puts "\n #{output_hand(player_hand)}"
  end

  def output_hand(hand)
    hand.each do |card|
      puts "#{card.face} of #{card.suit}, value = #{card.value}"
    end
    puts "Total value: #{get_value(hand)}"
  end

  def player_choice
    puts "Would you like to 'hit' or 'stand'? [h/s]"
    choice = STDIN.gets.chomp
    if choice == "h"
      hit(player_hand)
      output_hand(player_hand)
    elsif choice == "s"
      self.player_done = true
      true
    else
      puts "I didn't understand that"
      player_choice
    end
  end

  def hit(hand)
    hand.push(deck.draw)
  end

  def blackjack?
    get_value(player_hand) == 21
  end

  def bust?(hand)
    get_value(hand) > 21
  end

  def winner
    player = get_value(player_hand)
    dealer = get_value(dealer_hand)
    if player == 21 || dealer > 21 || (player > dealer && !bust?(player_hand)) || player == dealer
      "Player"
    else
      "Dealer"
    end
  end

  def output_results(winner)
    puts "\nDealer Hand: "
    output_hand(dealer_hand)
    puts "\nPlayer Hand: "
    output_hand(player_hand)
    puts "\n#{winner.upcase} WINS!"
  end

  def get_value(object)
    return object.value if object.respond_to? :value
    object.inject(0) { |sum, card| sum += card.value }
  end

end

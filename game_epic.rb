require_relative 'game_adventure'
# Epic mode for playing some blackjack.
class EpicGame < AdventureGame
  attr_accessor :game_results

  def initialize
    self.deck = Deck.new
    self.dealer_hand = []
    self.player_hand = []
    self.game_results = []
  end

  def play
    deal
    player_choice unless blackjack?(dealer_hand) || blackjack?(player_hand)
    dealer_choice unless blackjack?(dealer_hand) || blackjack?(player_hand) || bust?(player_hand)
    output_results(winner)
    play_again
  end

  def bust?(hand)
    if get_value(hand) > 21
      check_for_aces(hand)
      get_value(hand) > 21
    else
      false
    end
  end

  def check_for_aces(hand)
    high_aces = hand.select { |card| card.face == 'Ace' && card.value == 11 }
    high_aces.first.value = 1 if high_aces.any?
  end

  def output_results(winner)
    puts "\nDealer Hand: "
    output_hand(dealer_hand)
    puts "\nPlayer Hand: "
    output_hand(player_hand)
    puts "\n#{winner.upcase} WINS!"
    game_results << winner
  end

  def play_again
    puts 'Would you like to play again? [y/n]'
    response = STDIN.gets.chomp
    if response == 'y'
      reset
      play
    elsif response == 'n'
      output_final
      exit
    else play_again
    end
  end

  def output_final
    player_wins = game_results.count { |winner| winner == 'Player' }
    dealer_wins = game_results.count { |winner| winner == 'Dealer' }
    puts "You won #{player_wins} times and the dealer won #{dealer_wins}."
    puts 'Play again soon!'
  end

  def reset
    self.deck = Deck.new
    self.dealer_hand = []
    self.player_hand = []
  end
end
# This is a deck for shoe mode.
class Deck
  def initialize
    self.cards = []
    make_shoe
    shuffle
  end

  def make_shoe
    7.times do
      cards << make_deck
    end
    cards.flatten!
  end
end

EpicGame.new.play

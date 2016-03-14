require_relative 'game'
# Game class for adventure mode.
class AdventureGame < Game
  def play
    deal
    player_choice unless blackjack?(dealer_hand) || blackjack?(player_hand)
    dealer_choice unless blackjack?(dealer_hand) || blackjack?(player_hand) || bust?(player_hand)
    output_results(winner)
  end

  def dealer_choice
    until bust?(dealer_hand) || get_value(dealer_hand) > get_value(player_hand) || get_value(dealer_hand) == get_value(player_hand) && dealer_hand.length > player_hand.length
      hit(dealer_hand)
    end
  end

  def player_choice
    unless blackjack?(player_hand) || bust?(player_hand) || more_than_five?
      puts "Would you like to 'hit' or 'stand'? [h/s]"
      choice = STDIN.gets.chomp
      if choice == 'h'
        hit(player_hand)
        bust?(player_hand)
        output_hand(player_hand)
        player_choice
      elsif choice != 's'
        puts "I didn't understand that"
        player_choice
      end
    end
  end

  def winner
    player = get_value(player_hand)
    dealer = get_value(dealer_hand)
    if player == 21 && dealer != 21 || dealer > 21 || (more_than_five? || player > dealer) && player < 21
      'Player'
    else
      'Dealer'
    end
  end

  def blackjack?(hand)
    get_value(hand) == 21
  end

  def bust?(hand)
    get_value(hand) > 21
  end

  def more_than_five?
    player_hand.length > 5
  end
end

AdventureGame.new.play

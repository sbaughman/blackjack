require 'minitest/autorun'
require_relative 'game_epic'

class GameTest < MiniTest::Test

  def test_can_create_game
    game = EpicGame.new
    assert game.deck.cards.length == 52 * 7
    assert game.dealer_hand.length == 0
    assert game.player_hand.length == 0
  end

  def test_get_value_calculates_card_values_sum
    game = EpicGame.new
    game.dealer_hand.push(Card.new("clubs", "Queen"), Card.new("diamonds", "3"))
    assert game.get_value(game.dealer_hand) == 13
    assert game.get_value(Card.new("hearts", "King")) == 10
  end

  def test_deal_gives_two_cards_to_each
    game = EpicGame.new
    game.deal
    assert game.dealer_hand.length == 2
    assert game.player_hand.length == 2
  end

  def test_hit_method_adds_one_card_to_hand
    game = EpicGame.new
    game.hit(game.dealer_hand)
    assert game.dealer_hand.length == 1
    game.hit(game.dealer_hand)
    assert game.dealer_hand.length == 2
  end

  def test_dealer_wins_with_blackjack
    game = EpicGame.new
    game.dealer_hand.push(Card.new("", "Ace"), Card.new("", "King"))
    game.player_hand.push(Card.new("", "Ace"), Card.new("", "King"))
    assert game.winner == "Dealer"
  end

  def test_player_cant_win_with_bust
    game = EpicGame.new
    game.player_hand.push(Card.new("", "Ace"), Card.new("", "King"), Card.new("", "2"))
    game.dealer_hand.push(Card.new("", "2"))
    assert game.winner == "Dealer"
  end

  def test_dealer_cant_win_with_bust
    game = EpicGame.new
    game.dealer_hand.push(Card.new("", "Ace"), Card.new("", "King"), Card.new("", "2"))
    game.player_hand.push(Card.new("", "2"))
    assert game.winner == "Player"
  end

  def test_greater_value_wins_without_bust
    game = EpicGame.new
    card1 = Card.new("", "10")
    card2 = Card.new("", "6")
    card3 = Card.new("", "3")
    card4 = Card.new("", "Queen")
    game.player_hand.push(card1, card2)
    game.dealer_hand.push(card3, card4)
    assert game.winner == "Player"
    game.player_hand.clear.push(card2, card3)
    game.dealer_hand.clear.push(card1, card4)
    assert game.winner == "Dealer"
  end

  def assert_more_than_five_cards_no_bust_wins
    game = EpicGame.new
    card1 = Card.new("", "2")
    card2 = Card.new("", "2")
    card3 = Card.new("", "2")
    card4 = Card.new("", "2")
    card5 = Card.new("", "3")
    card6 = Card.new("", "3")
    card7 = Card.new("", "Jack")
    card8 = Card.new("", "King")
    game.player_hand.push(card1, card2, card3, card4, card5, card6)
    game.dealer_hand.push(card7, card8)
    assert game.winner == "Player"
  end

  def test_ace_changes_value_when_bust?
    game = EpicGame.new
    card1 = Card.new("", "Jack")
    card2 = Card.new("", "King")
    card3 = Card.new("", "Ace")
    game.player_hand.push(card1, card2, card3)
    game.bust?(game.player_hand)
    assert card3.value == 1
  end

  def test_only_one_ace_changes_value_when_bust?
    game = EpicGame.new
    card1 = Card.new("", "Ace")
    card2 = Card.new("", "Ace")
    card3 = Card.new("", "King")
    game.player_hand.push(card1, card2)
    game.bust?(game.player_hand)
    assert game.player_hand[0].value == 1
    assert game.player_hand[1].value == 11
    game.player_hand.push(card3)
    game.bust?(game.player_hand)
    assert game.player_hand[0].value == 1
    assert game.player_hand[1].value == 1
  end

  def test_game_tracks_winners_over_time
    game = EpicGame.new
    winner = "Dealer"
    game.output_results(winner)
    winner = "Player"
    game.output_results(winner)
    assert game.game_results[0] == "Dealer"
    assert game.game_results[1] == "Player"
  end

end

class CardTest < GameTest

  def test_can_create_card
    card = Card.new("spades", "Jack")
    assert card.face == "Jack"
    assert card.suit == "spades"
    assert card.value == 10
  end

end

class DeckTest < GameTest

  def test_can_create_shoe
    deck = Deck.new
    assert deck.cards.length == 52 * 7
  end

  def test_deck_can_tell_when_empty
    deck = Deck.new
    364.times do
      deck.cards.pop
    end
    assert deck.empty?
  end

  def test_can_draw_card
    deck = Deck.new
    card = deck.draw
    assert card.is_a? Card
  end

  def test_deck_is_shuffled
    deck = Deck.new
    card_array = deck.cards.take(13)
    assert card_array.map { |card| card.suit }.uniq.length > 1
  end

end

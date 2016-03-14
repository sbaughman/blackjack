require_relative 'game_adventure'


if ARGV[0] == "adventure"
  AdventureGame.new.play
elsif ARGV[0] == "epic"
  EpicGame.new.play
else
  Game.new.play
end

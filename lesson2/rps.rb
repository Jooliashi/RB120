module Gamebasics
  def prompt(message)
    puts "--> #{message}"
    puts "\n"
  end

  def pause
    sleep(0.7)
  end

  def clear_screen
    system('cls')
  end

  def enter_to_continue
    prompt("Press enter to continue")
    STDIN.gets
  end

  def format_rules(paragraph)
    length = paragraph.split(/[:.]/).map(&:length).max
    borders = "|" + "+" * (length + 2) + "|"
    puts borders
    paragraph.split(/[:.]/).each do |sentence|
      sentence.strip!
      puts "| " + sentence.center(length) + " |"
    end
    puts borders
  end

  def game_rules
    <<~MSG
    Here are the rules to win:
    Rock crushes Scissors and Lizard.
    Paper covers Rock, and disproves Spock.
    Scissors cuts Paper, and decapitates Lizard.
    Lizard poisons Spock, and eats Paper.
    Spock vaporizes Rock, and smashes Scissors.
    You will go first. Each time you win, you will get one point.
    The first to reach #{RPSGame::WINNING_SCORE} points will be the grand winner of the game.
    MSG
  end

  def display_rules
    format_rules(game_rules)
    enter_to_continue
  end

  def display_welcome_message
    clear_screen
    prompt("Welcome to Rock, Paper, Scissors, Lizard, Spock game!")
  end

  def display_goodbye_message
    prompt("Thanks for playing Rock, Paper, Scissors, Lizard, Spock Goodbye!")
  end

  def invalid_input
    prompt("Sorry, the input is invalid. Please input again.")
  end

  def cannot_be_empty
    prompt("Sorry, the input cannot be empty. Please re-enter.")
  end

  def user_choices
    <<~MSG
    Please choose:
    1) 'r' for rock
    2) 'p' for paper
    3) 'sc' for scissors
    4) 'l' for lizard
    5) 'sp' for spock
    MSG
  end

  def display_user_choices
    prompt(user_choices)
  end

  def play_again?
    pause
    prompt("Would you like to continue playing?(y/n)")
    answer = nil
    loop do
      answer = gets.chomp.downcase
      break if ['y', 'n', 'yes', 'no'].include? answer
      invalid_input
    end
    return true if answer == 'y' || answer == 'yes'
    false
  end

  def reset_game?
    prompt("Would you like to play another championship?")
    answer = nil
    loop do
      answer = gets.chomp.downcase
      break if ['y', 'n', 'yes', 'no'].include? answer
      invalid_input
    end
    return true if answer == 'y' || answer == 'yes'
    false
  end
end

class Player
  attr_accessor :all_moves
  attr_reader :move, :name

  include Gamebasics

  def initialize
    set_name
    self.all_moves = []
  end

  private

  attr_writer :move, :name

  def choice_interpreter(choice)
    case choice
    when 'r' then Rock.new
    when 'l' then Lizard.new
    when 'p' then Paper.new
    when 'sc' then Scissors.new
    when 'sp' then Spock.new
    end
  end
end

class Human < Player
  include Gamebasics

  def choose
    choice = nil
    loop do
      display_user_choices
      choice = gets.chomp
      break if valid_choice?(choice)
      invalid_input
    end
    self.move = choice_interpreter(choice)
    all_moves << move.name
  end

  private

  def set_name
    n = ''
    prompt("What's your name?")
    loop do
      n = gets.chomp
      break unless n.empty?
      cannot_be_empty
    end
    self.name = n
  end

  def valid_choice?(choice)
    Move::VALUES.include? choice
  end
end

class Computer < Player
  attr_reader :personality

  private

  def default_random_choice
    [Rock, Paper, Scissors, Lizard, Spock].sample.new
  end
end

class R2d2 < Computer
  def initialize
    @personality = "stubborn"
    super
  end

  def choose
    self.move = Rock.new
    all_moves << move.name
  end

  private

  def set_name
    self.name = "R2D2"
  end
end

class Hal < Computer
  def initialize
    @personality = "biased"
    super
  end

  def choose
    self.move = rand(10) > 3 ? Scissors.new : default_random_choice
    all_moves << move
  end

  private

  def set_name
    self.name = "Hal"
  end
end

class Chappie < Computer
  def initialize
    @personality = "consistent"
    super
  end

  def choose
    if rand(10) > 3 && !all_moves.empty?
      move
    else
      self.move = default_random_choice
    end
    all_moves << move.name
  end

  private

  def set_name
    self.name = "Chappie"
  end
end

class Sonny < Computer
  def initialize
    @personality = "calculative"
    super
  end

  def choose
    self.move = choice_interpreter(Move::VALUES[all_moves.length % 5])
    all_moves << move.name
  end

  private

  def set_name
    self.name = "Sonny"
  end
end

class Move
  attr_reader :beats, :name

  VALUES = ['r', 'sc', 'l', 'sp', 'p']

  def <=>(other_move)
    return 1 if beats.include?(other_move.name)
    return -1 if other_move.beats.include?(name)
    0
  end

  def to_s
    name.to_s
  end
end

class Rock < Move
  def initialize
    @name = "rock"
    @beats = ["scissors", "lizard"]
  end
end

class Paper < Move
  def initialize
    @name = "paper"
    @beats = ["rock", "spock"]
  end
end

class Scissors < Move
  def initialize
    @name = "scissors"
    @beats = ["paper", "lizard"]
  end
end

class Spock < Move
  def initialize
    @name = "spock"
    @beats = ["rock", "scissors"]
  end
end

class Lizard < Move
  def initialize
    @name = "lizard"
    @beats = ["spock", "paper"]
  end
end

class RPSGame
  attr_reader :human, :computer, :score

  include Gamebasics

  WINNING_SCORE = 10

  def initialize
    display_welcome_message
    display_rules
    @human = Human.new
    @computer = [Hal, R2d2, Chappie, Sonny].sample.new
    @score = { @human => 0, @computer => 0 }
  end

  def play
    display_players
    loop do
      one_game_rounds
      break unless grand_winner?
      annouce_grand_winner
      break unless reset_game?
      new_match
    end
    display_goodbye_message
  end

  private

  attr_writer :human, :computer, :score

  def display_players
    prompt("Hello #{human.name}. " \
           "you are playing against #{computer.name} today.")
    prompt("#{computer.name} is a #{computer.personality} player")
    pause
  end

  def display_moves
    pause
    prompt("You chose #{human.move}")
    prompt("#{computer.name} chose #{computer.move}")
  end

  def display_winner
    case human.move <=> computer.move
    when 1
      prompt("You won!")
      @score[@human] += 1
    when -1
      prompt("#{computer.name} won!")
      @score[@computer] += 1
    else
      prompt("It's a tie!")
    end
  end

  def display_score
    pause
    prompt("Current score You vs #{computer.name}:")
    prompt("#{@score[@human]} vs #{@score[@computer]}")
  end

  def grand_winner?
    @score.values.any? { |value| value == WINNING_SCORE }
  end

  def annouce_grand_winner
    pause
    if @score[@computer] == WINNING_SCORE
      prompt("#{computer.name} has won this game and is the grand winner!")
    else
      prompt("#{human.name} has won this game and is the grand winner!")
    end
    prompt("We will start a new match if you would like to play again")
  end

  def check_historical_moves
    prompt("Would you like to check historical moves?")
    answer = ''
    loop do
      answer = gets.chomp.downcase
      break if ["yes", 'y', 'n', 'no'].include?(answer)
      invalid_input
    end
    display_historical_moves if answer == "yes" || answer == 'y'
  end

  def display_historical_moves
    if human.all_moves.empty?
      prompt("These has been no moves yet.")
    else
      prompt("Your moves have been: #{human.all_moves}.")
      prompt("#{computer.name}'s moves have been #{computer.all_moves}.")
    end
    enter_to_continue
  end

  def one_game_rounds
    loop do
      human.choose
      computer.choose
      display_moves
      display_winner
      display_score
      check_historical_moves
      break if grand_winner? || !play_again?
    end
  end

  def new_match
    clear_screen

    self.computer = [Hal, R2d2, Chappie, Sonny].sample.new
    self.score = { @human => 0, @computer => 0 }
    human.all_moves = []

    display_players
  end
end

RPSGame.new.play

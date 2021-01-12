module Messagable
  def clear_screen
    system('clear')
  end

  def pause_prompt
    sleep(1.5)
  end

  def enter_to_continue
    prompt("Press enter to continue with the game.")
    STDIN.gets
  end

  def prompt(message)
    puts "=> #{message}"
    puts "\n"
  end

  def rules_message
    <<~MSG
    Here are the rules to win:
    > Rock crushes Scissors, and crushes Lizard
    > Paper covers Rock, and disproves Spock
    > Scissors cuts Paper, and decapitates Lizard
    > Lizard poisons Spock, and eats Paper
    > Spock vaporizes Rock, and smashes Scissors
    >>> You'll make your choice first, then the computer will take their turn.
    >>> Each round won will be worth 1 point.
    >>> The first to reach #{RPSGame::WINNING_SCORE} points will be crowned the grand winner. Good luck!
    MSG
  end

  def display_rules
    clear_screen
    prompt(rules_message)
    enter_to_continue
  end
end

class Move
  attr_reader :name, :winning_actions

  VALUES = {
    'rock' => 'r',
    'paper' => 'p',
    'scissors' => 'sc',
    'lizard' => 'l',
    'spock' => 'sp'
  }

  def >(other_move)
    winning_actions.key?(other_move.name)
  end

  def to_s
    name.capitalize
  end
end

class Rock < Move
  def initialize
    @name = 'rock'
    @winning_actions = { 'scissors' => 'crushes', 'lizard' => 'crushes' }
  end
end

class Paper < Move
  def initialize
    @name = 'paper'
    @winning_actions = { 'rock' => 'covers', 'spock' => 'disproves' }
  end
end

class Scissors < Move
  def initialize
    @name = 'scissors'
    @winning_actions = { 'paper' => 'cuts', 'lizard' => 'decapitates' }
  end
end

class Lizard < Move
  def initialize
    @name = 'lizard'
    @winning_actions = { 'spock' => 'poisons', 'paper' => 'eats' }
  end
end

class Spock < Move
  def initialize
    @name = 'spock'
    @winning_actions = { 'rock' => 'vaporizes', 'scissors' => 'smashes' }
  end
end

class Player
  attr_accessor :moves, :name, :score

  def initialize
    @score = 0
    @moves = []
    set_name
  end

  def current_move
    moves.last
  end

  def moves_display
    if moves.empty?
      'No moves have been made yet.'
    else
      moves.map.with_index do |move, index|
        "> Round #{index + 1}: #{move}"
      end
    end
  end

  private

  def official_choice(choice)
    choice = Move::VALUES.key(choice) if Move::VALUES.value?(choice)
    case choice
    when 'rock' then Rock.new
    when 'paper' then Paper.new
    when 'scissors' then Scissors.new
    when 'lizard' then Lizard.new
    when 'spock' then Spock.new
    end
  end
end

class Human < Player
  include Messagable

  def choice_message
    <<~MSG
    Choose one (Enter the full option name or abbreviation):
    1) 'rock' or 'r'
    2) 'paper' or 'p'
    3) 'scissors' or 'sc'
    4) 'lizard' or 'l'
    5) 'spock' or 'sp'
    > Enter 'rules' if you'd like a refresher on the game rules.
    MSG
  end

  def display_choice_message
    clear_screen
    prompt(choice_message)
  end

  def valid_choice?(choice)
    Move::VALUES.key?(choice) || Move::VALUES.value?(choice)
  end

  def display_invalid_choice
    prompt("Sorry, that's not a valid choice.")
    pause_prompt
  end

  def choose
    choice = nil
    loop do
      display_choice_message
      choice = gets.chomp.downcase
      break if valid_choice?(choice)
      choice == 'rules' ? display_rules : display_invalid_choice
    end
    moves << official_choice(choice)
  end

  private

  def valid_name?(n)
    /\A[[:alpha:]]*[[:blank:]]?([[:alpha:]]+)\z/.match(n)
  end

  def set_name
    n = ''
    loop do
      prompt("Enter your name:")
      n = gets.chomp
      break if valid_name?(n)
      prompt("Please use a valid name (alphabetic characters only).")
    end
    self.name = n
  end
end

class Computer < Player
  def initialize
    @robot = [R2D2.new, Hal.new, Chappie.new, Sonny.new, Number5.new].sample
    super
  end

  def choose
    choice = official_choice(robot.personality.sample)
    moves << choice
  end

  private

  attr_reader :robot

  def set_name
    self.name = robot.title
  end

  protected

  attr_reader :title, :personality
end

class R2D2 < Computer
  def initialize
    @title = 'R2D2'
    @personality = ['rock']
  end
end

class Hal < Computer
  def initialize
    @title = 'Hal'
    @personality = ['scissors'] * 2 + ['rock']
  end
end

class Chappie < Computer
  def initialize
    @title = 'Chappie'
    @personality = Move::VALUES.keys
  end
end

class Sonny < Computer
  def initialize
    @title = 'Sonny'
    @personality = ['paper'] * 5 + ['lizard'] * 4 + ['spock'] * 3 +
                   ['rock'] * 2 + ['scissors']
  end
end

class Number5 < Computer
  def initialize
    @title = 'Number 5'
    @personality = ['rock', 'spock']
  end
end

# Game Orchestration Engine
class RPSGame
  include Messagable

  WINNING_SCORE = 10

  def initialize
    @human = Human.new
    @computer = Computer.new
  end

  def play
    display_welcome_message
    display_rules
    loop do
      play_rounds
      display_grand_winner
      display_move_history
      break unless replay?
      reset_match
    end
    display_goodbye_message
  end

  private

  attr_accessor :human, :computer

  def welcome_message
    <<~MSG
    Welcome to Rock, Paper, Scissors, Lizard, Spock, #{human.name}!
    You will be playing against #{computer.name}!
    Let's play!
    MSG
  end

  def display_welcome_message
    clear_screen
    prompt(welcome_message)
    enter_to_continue
  end

  def make_moves
    human.choose
    computer.choose
  end

  def display_current_moves
    clear_screen
    prompt("You chose #{human.current_move}.")
    pause_prompt
    prompt("#{computer.name} chose #{computer.current_move}.")
    pause_prompt
  end

  def display_move_history
    prompt("Your history of moves:")
    puts human.moves_display
    puts "\n"
    prompt("#{computer.name}'s history of moves:")
    puts computer.moves_display
    puts "\n"
    enter_to_continue
  end

  def empty_move_history?
    human.moves.empty?
  end

  def move_history_message
    <<~MSG
    Would you like to see the history of moves?
    > Enter 'Y' for yes / 'N' for no
    MSG
  end

  def display_move_history?
    clear_screen
    prompt(move_history_message)

    answer = ''
    loop do
      answer = gets.chomp
      break if ['y', 'yes', 'n', 'no'].include?(answer.downcase)
      puts "\n"
      prompt("Must enter 'Y' for yes or 'N' for no.")
    end

    ['y', 'yes'].include?(answer.downcase)
  end

  def human_won?
    human.current_move > computer.current_move
  end

  def computer_won?
    computer.current_move > human.current_move
  end

  def winning_action
    if human_won?
      human.current_move.winning_actions[computer.current_move.name]
    elsif computer_won?
      computer.current_move.winning_actions[human.current_move.name]
    end
  end

  def move_action_message
    if human_won?
      "#{human.current_move} #{winning_action} #{computer.current_move}."
    elsif computer_won?
      "#{computer.current_move} #{winning_action} #{human.current_move}."
    else
      "Looks like you and #{computer.name} both chose #{human.current_move}. " \
      "Neither one can prevail over the other..."
    end
  end

  def display_move_action
    prompt(move_action_message)
    pause_prompt
  end

  def display_move_details
    display_current_moves
    display_move_action
  end

  def display_round_result
    if human_won?
      prompt("You won this round!")
    elsif computer_won?
      prompt("#{computer.name} won this round!")
    else
      prompt("It's a tie!")
    end
    enter_to_continue
  end

  def update_score
    if human_won?
      human.score += 1
    elsif computer_won?
      computer.score += 1
    end
  end

  def current_score_message
    <<~MSG
    The current point standings are:
    > You: #{human.score}
    > #{computer.name}: #{computer.score}
    MSG
  end

  def display_current_score
    clear_screen
    prompt(current_score_message)
    pause_prompt
  end

  def match_over?
    human.score == WINNING_SCORE || computer.score == WINNING_SCORE
  end

  def match_status_message
    if match_over?
      "And that's #{WINNING_SCORE} rounds won! " \
      "Looks like we've found our grand winner..."
    else
      "Game's not over yet! " \
      "Remember, the first to #{WINNING_SCORE} points wins. " \
      "On to the next round..."
    end
  end

  def display_match_status
    prompt(match_status_message)
    enter_to_continue
  end

  def display_grand_winner
    clear_screen
    if human.score == WINNING_SCORE
      prompt("You are the grand winner of this match!")
    else
      prompt("The grand winner of this match is #{computer.name}!")
    end
    enter_to_continue
  end

  def replay_message
    <<~MSG
    Would you like to play again?
    > Enter 'Y' to play again / 'N' to quit
    MSG
  end

  def replay?
    clear_screen
    prompt(replay_message)

    replay_input = ''
    loop do
      replay_input = gets.chomp
      break if ['y', 'yes', 'n', 'no'].include?(replay_input.downcase)
      puts "\n"
      prompt("Must enter 'Y' for yes or 'N' for no.")
    end

    ['y', 'yes'].include?(replay_input.downcase)
  end

  def display_new_computer
    clear_screen

    self.computer = Computer.new

    prompt("Your opponent for this match will be #{computer.name}. Let's play!")
    enter_to_continue
  end

  def reset_match
    display_new_computer
    human.score = 0
    human.moves = []
  end

  def display_goodbye_message
    prompt("Thank you for playing! Have a nice day!")
  end

  def play_rounds
    loop do
      display_move_history if !empty_move_history? && display_move_history?
      make_moves

      display_move_details
      display_round_result

      update_score
      display_current_score

      display_match_status
      break if match_over?
    end
  end
end

RPSGame.new.play
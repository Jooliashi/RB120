require 'pry'
module Format 
  def prompt(message)
    puts "--> #{message}"
  end 
end 

class RPSGame
  attr_accessor :human, :computer, :score

  include Format

  WINNING_SCORE = 3

  def initialize
    @human = Human.new
    @computer = Computer.new
    @score = {@human => 0, @computer => 0}
  end

  def display_welcome_message
    prompt("Welcome to <<Rock, Paper, Scissors, Lizard, Spock>> game #{human.name}!")
  end

  def display_goodbye_message
    prompt("Thanks for playing Rock, Paper, Scissors, Lizard, Spock Goodbye!")
  end

  def display_moves
    prompt("#{human.name} chose #{human.move.value}")
    prompt("#{computer.name} chose #{computer.move.value}")
  end

  def display_winner
    case human.move <=> computer.move 
    when 1
      prompt("#{human.name} won!")
      @score[@human] += 1
    when -1 
      prompt("#{computer.name} won!")
      @score[@computer] += 1
    else
      prompt("It's a tie!")
    end
  end

  def display_score 
    prompt("Current score #{human.name} vs #{computer.name}:")
    prompt("#{@score[@human]} vs #{@score[@computer]}")
  end 

  def play_again?
    prompt("Would you like to play again?(y/n)")
    answer = nil
    loop do
      answer = gets.chomp.downcase
      break if ['y', 'n'].include? answer
      prompt "Sorry, invalid input"
    end
    return true if answer == 'y'
    false
  end

  def grand_winner?
    @score.values.any? {|value| value == WINNING_SCORE}
  end 

  def annouce_grand_winner
    if @score[@computer] == WINNING_SCORE
      prompt("#{computer.name} has won this game and is the grand winner!")
    else 
      prompt("#{human.name} has won this game and is the grand winner!")
    end 
    prompt("Please restart a new game if you would like to play again")
  end 

  def play
    display_welcome_message
    loop do
      human.choose
      computer.choose
      display_moves
      display_winner
      display_score
      break if grand_winner? || !play_again? 
    end
    annouce_grand_winner if grand_winner? == true 
    display_goodbye_message
  end
end

class Player
  attr_accessor :move, :name

  include Format

  def initialize
    set_name
  end
end

class Human < Player
  def set_name
    n = ''
    prompt("What's your name?")
    loop do
      n = gets.chomp
      break unless n.empty?
      prompt("Sorry, must enter a value.")
    end
    self.name = n
  end

  def choose
    choice = nil
    loop do
      prompt("Please choose rock, paper, scissors, spock, or lizard(with full name):")
      choice = gets.chomp.downcase
      break if Move::VALUES.include? choice
      prompt("Sorry, invalid input")
    end
    self.move = Move.new(choice)
  end
end

class Computer < Player
  def set_name
    self.name = ['R2D2', 'Hal', 'Chappie', 'Sonny'].sample
  end

  def choose
    self.move = Move.new(Move::VALUES.sample)
  end
end


class Move
  attr_reader :value

  VALUES = ['rock', 'paper', 'scissors', 'lizard', 'spock']

  def initialize(value)
    case value 
    when 'rock' then @value = Rock.new 
    when 'paper' then @value = Paper.new
    when 'scissors' then @value = Scissors.new
    when 'lizard' then @value = Lizard.new
    when 'Spock' then @value = Spock.new 
    end 
  end

  def <=>(other_move)
    @value <=> other_move.value
  end

  def paper?
    @value.class == Paper
  end

  def rock?
    @value.class == Rock
  end

  def scissors?
    @value.class = Scissors
  end

  def spock?
    @value.class == Spock
  end 

  def lizard?
    @value.class == Lizard
  end 

  def to_s
    "#{value.class}"
  end

end

class Rock < Move 
  def initialize
  end

  def <=>(other_move)
    case
    1 when other_move.scissors? || other_move.lizard?
    -1 when other_move.spock? || other_move.paper?
    else 
      0
    end 
  end
end

class Paper < Move 
  def initialize
  end 
  def <=>(other_move)
    case
    1 when other_move.rock? || other_move.spock?
    -1 when other_move.scissors? || other_move.lizard?
    else 
      0
    end 
  end
end

class Scissors < Move
  def initialize
  end

  def <=>(other_move)
    case
    1 when other_move.paper? || other_move.lizard?
    -1 when other_move.rock? || other_move.spock?
    else 
      0 
    end 
  end
end

class Spock < Move
  def initialize
  end

  def <=>(other_move)
    case
    1 when other_move.rock? || other_move.scissors?
    -1 when other_move.paper? || other_move.lizard?
    else 
      0 
    end 
  end
end

class Lizard < Move
  def initialize
  end

  def <=>(other_move)
    case
    1 when other_move.spock? || other_move.paper?
    -1 when other_move.rock? || other_move.scissors?
    else 
      0
    end  
  end
end


RPSGame.new.play

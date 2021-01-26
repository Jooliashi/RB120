require 'pry'

module GameBasics
  def clear_screen
    system('cls') || system('clear')
  end

  def prompt(message)
    puts "=> #{message}\n"
  end

  def pause
    sleep(0.7)
  end

  def enter_to_continue
    prompt("Press enter to continue with the game.")
    STDIN.gets
  end
end

class Board
  include GameBasics

  WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9],
                   [1, 5, 9], [3, 5, 7], [1, 4, 7],
                   [2, 5, 8], [3, 6, 9]]
  BOARD_SIZE = 9

  def initialize
    @squares = empty_board(BOARD_SIZE)
    @sample = instruction_board(BOARD_SIZE)
  end

  def display_game_board
    clear_screen
    display(squares)
  end

  def display_sample_board
    display(sample)
  end

  def []=(num, marker)
    squares[num].mark = marker
  end

  def unmarked_keys
    squares.select { |_, square| square.unmarked? }.keys
  end

  def winning_mark
    WINNING_LINES.each do |line|
      squares = @squares.values_at(*line)
      if three_identical_marks?(squares)
        return squares.first.mark
      end
    end
    nil
  end

  private

  attr_accessor :squares, :sample

  def display(board)
    puts "------+-----+------
          |  #{board[1]}  |  #{board[2]}  |  #{board[3]}  |
          ------+-----+------
          |  #{board[4]}  |  #{board[5]}  |  #{board[6]}  |
          ------+-----+------
          |  #{board[7]}  |  #{board[8]}  |  #{board[9]}  |
          ------+-----+------".lines
      .map { |line| line.strip.center(100) }
      .join("\n")
  end

  def instruction_board(size)
    hsh = {}
    1.upto(size) { |square| hsh[square] = Square.new(square.to_s) }
    hsh
  end

  def empty_board(size)
    hsh = {}
    1.upto(size) { |square| hsh[square] = Square.new }
    hsh
  end

  def three_identical_marks?(squares)
    markers = squares.select(&:marked?).collect(&:mark)
    return false if markers.size != 3
    markers.min == markers.max
  end
end

class Square
  INITIAL_MARKER = " "

  attr_accessor :mark

  def initialize(marker=INITIAL_MARKER)
    @mark = marker
  end

  def to_s
    mark
  end

  def unmarked?
    mark == INITIAL_MARKER
  end

  def marked?
    !unmarked?
  end
end

class Player
  attr_reader :marker

  include GameBasics

  HUMAN_MARKER = "X"
  COMPUTER_MARKER = "O"
end

class Human < Player
  attr_reader :name

  def initialize
    @marker = HUMAN_MARKER
    @name = set_name
  end

  def choose_square(squares)
    puts "Choose a square in #{squares}: "
    square = nil
    loop do
      square = gets.chomp.to_i
      break if squares.include?(square)
      puts "Sorry, that's not a valid choice."
    end
    square
  end

  private

  attr_writer :name

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

  def valid_name?(n)
    /\A[[:alpha:]]*[[:blank:]]?([[:alpha:]]+)\z/.match(n)
  end
end

class Computer < Player
  def initialize
    @marker = COMPUTER_MARKER
  end

  def choose_square(squares)
    squares.sample
  end
end

class TicTacToe
  include GameBasics

  def initialize
    @board = Board.new
    @human = Human.new
    @computer = Computer.new
    @current_mover = nil
  end

  def play
    display_welcome_message
    display_rules
    main_game
    display_goodbye_message
  end

  private

  attr_accessor :board, :human, :computer, :current_mover

  def main_game
    loop do
      determine_first_mover
      loop do
        current_player_moves
        break if a_winner? || tie?
      end
      display_result
      break unless play_again?
      reset_game
    end
  end

  def display_welcome_message
    clear_screen
    prompt("Welcome to Tic Tac Toe, #{human.name}!\n")
    pause
  end

  def determine_first_mover
    prompt("Would you like to move first? Please enter 'yes' or 'no'")
    self.current_mover = yes_or_no ? human : computer
  end

  def display_goodbye_message
    prompt("Thank you for playing Tic Tac Toe, goodbye!")
  end

  def display_rules
    prompt(game_rules)
    pause
    board.display_sample_board
    prompt("Here is an example of the board; each square is assigned
            a number for the purpose of reference\n")
    enter_to_continue
  end

  def game_rules
    <<~MSG
    The rules are:
      1. The game is played on a grid that's 3 squares by 3 squares.
      2. You are #{human.marker}, the computer is #{computer.marker}.
      3. The first player to get 3 of her marks in a row (up, down, across, or diagonally) is the winner.
      4. When all 9 squares are full, the game is over.
    MSG
  end

  def display_game_board
    board.display_game_board
  end

  def current_player_moves
    if current_mover == human
      human_turn
      self.current_mover = computer
    else
      computer_turn
      self.current_mover = human
    end
  end

  def human_turn
    display_game_board
    square = human.choose_square(board.unmarked_keys)
    board[square] = human.marker
    display_game_board
  end

  def a_winner?
    human_wins? || computer_wins?
  end

  def computer_wins?
    board.winning_mark == computer.marker
  end

  def human_wins?
    board.winning_mark == human.marker
  end

  def tie?
    board.unmarked_keys.empty?
  end

  def computer_turn
    prompt("It's computer's turn now")
    pause
    square = computer.choose_square(board.unmarked_keys)
    board[square] = computer.marker
    prompt("computer chose square #{square}")
    display_game_board
  end

  def display_result
    display_winner_message if a_winner?
    display_tie_message if tie?
  end

  def display_winner_message
    if human_wins?
      prompt("Congratulations, you have won!")
    else
      prompt("Computer has won, better luck next time")
    end
  end

  def display_tie_message
    prompt("The game has reached a tie.")
  end

  def play_again?
    prompt("Would you like to play again? please type 'yes' or 'no'")
    yes_or_no
  end

  def yes_or_no
    answer = nil
    loop do
      answer = gets.chomp.downcase
      break if ['y', 'n', 'yes', 'no'].include?(answer)
      prompt("Sorry, the answer is invalid. Try again")
    end
    return true if ['y', 'yes'].include?(answer)
    false
  end

  def reset_game
    self.board = Board.new
  end
end

game = TicTacToe.new
game.play

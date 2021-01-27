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

  def joinor(array, spliter = ', ', ending = 'or')
    case array.size
    when 1
      array.first
    when 2
      "#{array.first} #{ending} #{array.last}"
    else
      array_str = array.map(&:to_s)
      array_str.last.insert(0, " #{ending} ")
      array_str[0...-1].join(spliter) + array_str.last
    end
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

  def random_key
    unmarked_keys.sample
  end

  def winning_mark
    WINNING_LINES.each do |line|
      squares = @squares.values_at(*line)
      if n_identical_marks?(3, squares)
        return squares.first.mark
      end
    end
    nil
  end

  def opportunity_square(mark)
    WINNING_LINES.each do |line|
      squares = @squares.values_at(*line)
      if n_identical_marks?(2, squares) &&
         identify_mark_in_roll(squares) == mark
        return line.select do |num|
          self.squares[num].mark == Square::INITIAL_MARKER
        end.first
      end
    end
    nil
  end

  def center_square_available
    squares[5].unmarked?
  end

  private

  attr_accessor :squares, :sample

  def identify_mark_in_roll(rolls)
    rolls.select(&:marked?).first.mark
  end

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

  def n_identical_marks?(n, squares)
    markers = squares.select(&:marked?).collect(&:mark)
    return false if markers.size != n
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
  attr_reader :marker, :name

  include GameBasics

  HUMAN_MARKER = "X"
  COMPUTER_MARKER = "O"
end

class Human < Player
  def initialize
    @name = set_name
    @marker = set_marker
  end

  def choose_square(squares)
    puts "Choose a square in #{joinor(squares)}: "
    square = nil
    loop do
      square = gets.chomp.to_i
      break if squares.include?(square)
      puts "Sorry, that's not a valid choice."
    end
    square
  end

  private

  attr_writer :name, :marker

  def set_marker
    prompt("Hi #{name}, Would you like to set your own marker?
  Enter any single alphabet from a to z or press enter for default marker 'X'")
    n = ''
    loop do
      n = gets.chomp
      break if valid_marker?(n) || n == ''
      prompt("Please choose a valid marker or press enter for defaults")
    end
    self.marker = n == "" ? HUMAN_MARKER : n
  end

  def valid_marker?(n)
    n.size == 1 && /\A[[:alpha:]]*[[:blank:]]?([[:alpha:]]+)\z/.match(n)
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

  def valid_name?(n)
    /\A[[:alpha:]]*[[:blank:]]?([[:alpha:]]+)\z/.match(n)
  end
end

class Computer < Player
  def initialize
    @marker = COMPUTER_MARKER
    @name = "Edward the Vampire"
  end

  def choose_square(board)
    return advantage_square(board) if advantage_square(board)
    return at_risk_square(board) if at_risk_square(board)
    return 5 if board.center_square_available
    board.random_key
  end

  private

  def at_risk_square(board)
    board.opportunity_square(Player::HUMAN_MARKER)
  end

  def advantage_square(board)
    board.opportunity_square(Player::COMPUTER_MARKER)
  end
end

class TicTacToe
  include GameBasics

  WINNING_STRIKES = 5

  def initialize
    @board = Board.new
    @human = nil
    @computer = Computer.new
    @current_mover = nil
    @score = nil
    @initial_mover = nil
  end

  def play
    display_welcome_message
    display_rules
    main_game
    declare_champion
    display_goodbye_message
  end

  private

  attr_accessor :board, :human, :computer,
                :current_mover, :score, :initial_mover

  def main_game
    player_choice
    loop do
      one_round
      break if a_champion? || !continue_playing?
      reset_game
    end
  end

  def one_round
    loop do
      current_player_moves
      break if a_winner? || tie?
    end
    update_score
    display_result
  end

  def player_choice
    initialize_player
    determine_first_mover
  end

  def initialize_player
    clear_screen
    self.human = Human.new
    initialize_score
  end

  def initialize_score
    @score = { @human => 0, @computer => 0 }
  end

  def display_welcome_message
    clear_screen
    prompt("Welcome to Tic Tac Toe!")
    pause
  end

  def determine_first_mover
    prompt("You are playing against #{computer.name}."\
      " Would you like to move first? Please enter 'yes' or 'no'")
    self.initial_mover = yes_or_no ? human : computer
    self.current_mover = initial_mover
  end

  def display_goodbye_message
    prompt("Thank you for playing Tic Tac Toe, goodbye!")
  end

  def display_rules
    prompt(game_rules)
    pause
    board.display_sample_board
    prompt("Here is an example of the board; each square is assigned"\
            " a number for the purpose of reference\n")
    enter_to_continue
  end

  def game_rules
    <<~MSG
    The rules are:
      1. The game is played on a grid that's 3 squares by 3 squares.
      2. You are #{Player::HUMAN_MARKER}, the computer is #{Player::COMPUTER_MARKER}.
      3. The first player to get 3 of her marks in a row (up, down, across, or diagonally) is the winner.
      4. When all 9 squares are full, the game is over.
      5. The player that wins #{WINNING_STRIKES} games wins the tournament.
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

  def update_score
    if human_wins?
      score[human] += 1
    else
      score[computer] += 1
    end
  end

  def tie?
    board.unmarked_keys.empty?
  end

  def computer_turn
    prompt("computer's turn...")
    pause
    square = computer.choose_square(board)
    board[square] = computer.marker
    prompt("computer chose square #{square}")
    display_game_board
  end

  def display_result
    display_winner_message if a_winner?
    display_tie_message if tie?
    display_score
  end

  def display_score
    prompt("You won #{score[human]} times," \
      "and computer won #{score[computer]} times")
  end

  def display_winner_message
    if human_wins?
      prompt("Congratulations, you have won!")
    else
      prompt("Computer has won")
    end
  end

  def display_tie_message
    prompt("Looks like it's a tie.")
  end

  def continue_playing?
    prompt("Would you like to continue playing? please type 'yes' or 'no'")
    yes_or_no
  end

  def a_champion?
    score.values.any? { |value| value == WINNING_STRIKES }
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
    self.current_mover = initial_mover
  end

  def declare_champion
    if score[human] == 5
      prompt("You have won the tournament!")
    elsif score[computer] == 5
      prompt("Computer has won the tournament, better luck next time!")
    end
  end
end

game = TicTacToe.new
game.play

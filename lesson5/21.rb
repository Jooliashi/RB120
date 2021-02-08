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

  def play_again?
    prompt("Would you like to play_again? please type 'yes' or 'no'")
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

  def format_box(paragraph)
    length = paragraph.split(/[:.]/).map(&:length).max
    borders = "*" + "*" * (length + 2) + "*"
    puts borders
    paragraph.split(/[:.]/)[0..-2].each do |sentence|
      sentence.strip!
      puts "* " + sentence.center(length) + " *"
    end
    puts borders
  end
end

module Hand
  def total
    total = cards.map(&:face).reduce(0) do |tot, face|
      case face
      when "J", "Q", "K" then tot + 10
      when "A" then tot + 11
      else
        tot + face.to_i
      end
    end

    adjust_aces(total) if total > 21
    total
  end

  def adjust_aces(total)
    cards.select(&:ace?).count.times do
      total -= 10
    end
    total
  end

  def <<(card)
    cards << card
  end

  def busted?
    total > 21
  end

  def show_cards
    puts "---#{name}'s Hand---"
    cards.each do |card|
      prompt(card.to_s)
    end
    prompt("Total: #{total}")
    puts ""
  end
end

class Participant
  include GameBasics, Hand

  attr_accessor :cards, :name

  def initialize
    @cards = []
    @name = set_name
  end

  def reset
    @cards = []
  end
end

class Player < Participant
  def stay?
    prompt("Would you like to hit or stay? Please input 'h' or 's'.")
    true_for_stay
  end

  private

  def true_for_stay
    answer = nil
    loop do
      answer = gets.chomp.downcase
      break if ['h', 's', 'hit', 'stay'].include?(answer)
      prompt("Sorry, the answer is invalid. Try again")
    end
    return true if ['stay', 's'].include?(answer)
    false
  end
end

class Dealer < Participant
  ROBOTS = ['R2D2', 'Hal', 'Chappie', 'Sonny', 'Number 5']
  HAND_LIMIT = 17

  def show_cards(num_cards = 'half')
    if num_cards == 'half'
      puts "---- #{name}'s Hand ----"
      prompt(" ?? ")
      cards[1..-1].each do |card|
        prompt(card.to_s)
      end
      puts ""
    else
      super()
    end
  end

  def stay?
    total >= HAND_LIMIT
  end

  private

  def set_name
    self.name = ROBOTS.sample
  end
end

class Deck
  attr_reader :cards

  SUITS = ['H', 'D', 'S', 'C']
  FACES = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A']

  def initialize
    @cards = new_deck
  end

  def deal
    cards.pop
  end

  def reset
    @cards = new_deck
  end

  private

  def new_deck
    SUITS.each_with_object([]) do |suit, cards|
      FACES.each do |face|
        cards << Card.new(suit, face)
      end
    end.shuffle
  end
end

class Card
  SUIT = { 'H' => '♥',
           'D' => '♦',
           'S' => '♠',
           'C' => '♣' }
  FACES = { 'J' => 'Jack',
            'Q' => 'Queen',
            'K' => 'King',
            'A' => 'Ace' }

  attr_accessor :suit, :face

  def initialize(suit, face)
    @suit = suit
    @face = face
  end

  def to_s
    card_interpreter
  end

  def ace?
    face == "A"
  end

  private

  def card_interpreter
    suit = SUIT[self.suit]
    face = !FACES[self.face].nil? ? FACES[self.face] : self.face
    "The #{face} of #{suit}"
  end
end

class TwentyOneGame
  include GameBasics

  WINNING_SCORE = 3

  def initialize
    @dealer = Dealer.new
    @deck = Deck.new
  end

  def start
    display_welcome_message
    display_rules
    set_up_game
    main_game
    display_goodbye_message
  end

  private

  attr_reader :dealer, :player
  attr_accessor :current_player, :deck, :score, :rounds

  def set_up_game
    @player = Player.new
    @current_player = @player
    @score = { player => 0, dealer => 0 }
    @rounds = input_rounds
  end

  def main_game
    loop do
      one_tournament
      declare_champion
      break unless play_again?
      reset_game
    end
  end

  def set_up_cards
    first_two_cards
    show_cards
  end

  def input_rounds
    clear_screen
    prompt("Hi #{player.name}, "\
           "we will play in tournament style for this game.\n")
    prompt("How many rounds would you like to play?")
    user_input_number
  end

  def one_tournament
    loop do
      set_up_cards
      take_rounds
      break if a_champion?
      enter_to_continue
      reset_new_round
    end
  end

  def user_input_number
    answer = nil
    loop do
      answer = gets.chomp.to_i
      break if answer >= 1
      puts "Please enter an integer bigger than 0."
    end
    answer
  end

  def take_rounds
    loop do
      current_player_turn
      break if current_player == player || any_busted?
    end
    show_result
    update_score
    display_scores
  end

  def display_welcome_message
    clear_screen
    prompt("Welcome to the Twenty-One Game!\n")
  end

  def display_goodbye_message
    prompt("Thank you #{player.name} for playing the Twenty-One Game, goodbye!")
  end

  def game_rules
    <<~RULES
    HERE ARE THE RULES:
    You are playing against the dealer in this game.
    The goal is to amount your card values as near to 21 as possible without exceeding it.
    Moreover, you have to beat whatever hand the dealer has.
    Face cards are worth 10 points. Ace are 11 or 1.
    All others are worth the value printed on them.
    You are both dealt two cards to begin with.
    The winner is declared when either of you goes bust.
    or you both choose to stay.
    RULES
  end

  def display_rules
    prompt("Would you like to see the rules? Please input 'yes' or 'no'")
    return unless yes_or_no
    clear_screen
    format_box(game_rules)
    enter_to_continue
  end

  def first_two_cards
    2.times do
      player << deck.deal
      dealer << deck.deal
    end
  end

  def show_cards
    clear_screen
    player.show_cards
    dealer.show_cards
  end

  def display_turn
    prompt("#{current_player.name}'s turn...")
    pause
  end

  def switch_current_player
    self.current_player = current_player == player ? dealer : player
  end

  def current_player_turn
    display_turn
    loop do
      break if current_player.busted? || current_player.stay?
      current_player_hit
      show_cards
    end
    display_stay_statement if !current_player.busted?
    switch_current_player
  end

  def current_player_hit
    puts ""
    prompt("#{current_player.name} chooses to hit...")
    pause
    current_player << deck.deal
  end

  def any_busted?
    player.busted? || dealer.busted?
  end

  def show_result
    show_final_hand
    display_busted
    display_winner
  end

  def update_score
    if winning_player == player
      score[player] += 1
    elsif winning_player == dealer
      score[dealer] += 1
    end
  end

  def show_final_hand
    clear_screen
    player.show_cards
    dealer.show_cards('all')
    pause
  end

  def declare_champion
    if score[player] > score[dealer]
      prompt("You are the grand champion!")
    else
      prompt("#{dealer.name} is the grand champion!")
    end
  end

  def display_stay_statement
    puts ""
    prompt("#{current_player.name} chooses to stay")
    pause
  end

  def a_champion?
    score.values.any? { |value| value >= rounds }
  end

  def display_scores
    puts ""
    prompt("#{player.name} scored #{score[player]},"\
           " #{dealer.name} scored #{score[dealer]}")
    puts ""
    display_goal_score
  end

  def display_goal_score
    return unless !a_champion?
    prompt("First player to score #{rounds} wins the tournament\n")
  end

  def display_busted
    if player.busted?
      prompt("You are busted!")
    elsif dealer.busted?
      prompt("#{dealer.name} is busted!\n")
    end
    pause
  end

  def winning_player
    return dealer if player.busted?
    return player if dealer.busted?
    return player if dealer.total < player.total
    dealer if player.total < dealer.total
  end

  def display_winner
    winner = winning_player
    if !winner.nil?
      prompt("#{winner.name} won!")
    else
      prompt("This is a tie!")
    end
    pause
  end

  def reset_new_round
    deck.reset
    player.reset
    dealer.reset
    reset_current_player
  end

  def reset_current_player
    self.current_player = player
  end

  def reset_score
    self.score = { player => 0, dealer => 0 }
  end

  def reset_goal_rounds
    self.rounds = input_rounds
  end

  def reset_game
    reset_new_round
    reset_score
    reset_goal_rounds
  end
end

game = TwentyOneGame.new
game.start

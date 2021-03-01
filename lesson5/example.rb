module Inputable
  require 'io/console'

  def join_or(list, delim: ',', final: 'or')
    return list[0].to_s if list.size == 1
    return "#{list[0]} #{final} #{list[1]}" if list.size == 2

    "#{list[0..-2].join(delim + ' ')}#{delim} #{final} #{list[-1]}"
  end

  def user_input_choice(choices)
    answer = nil
    loop do
      answer = gets.chomp.downcase
      break if choices.include?(answer)
      puts "Please enter #{join_or(choices)}."
    end

    answer
  end

  def user_input_integer(range)
    answer = nil
    loop do
      answer = gets.chomp
      break if !answer.include?(".") && range.include?(answer.to_i)
      puts "Please enter a number from #{range.first} to #{range.last}."
    end

    answer.to_i
  end

  def press_any_key(prompt)
    print prompt
    STDIN.getch
    puts
  end
end

class Card
  attr_reader :rank, :suit

  RANKS = [:A, :K, :Q, :J, 10, 9, 8, 7, 6, 5, 4, 3, 2]
  SUITS = [:Hearts, :Diamonds, :Clubs, :Spades]

  BACK = <<~BACK_DOC
    ┌───────┐
    │░░░░░░░│
    │░░░░░░░│
    │░░░░░░░│
    │░░░░░░░│
    │░░░░░░░│
    └───────┘
  BACK_DOC

  def initialize(rank, suit)
    @rank = rank
    @suit = suit
  end

  def to_s
    <<~CARD
      ┌───────┐
      │#{rank.to_s.ljust(7)}│
      │       │
      │#{symbol.center(7)}│
      │       │
      │#{rank.to_s.rjust(7)}│
      └───────┘
    CARD
  end

  def value
    case rank
    when :A then 11
    when :K, :Q, :J then 10
    else rank
    end
  end

  private

  def symbol
    case suit
    when :Spades then '♠'
    when :Diamonds then '♦'
    when :Hearts then '♥'
    when :Clubs then '♣'
    end
  end
end

class Deck
  def initialize
    @deck = []
    Card::RANKS.each do |rank|
      Card::SUITS.each do |suit|
        @deck << Card.new(rank, suit)
      end
    end
    @deck.shuffle!
  end

  def draw_card
    @deck.pop
  end
end

class Hand
  attr_reader :hand

  def initialize
    @hand = []
  end

  def total
    aces_count = @hand.count { |card| card.rank == :A }
    total = @hand.inject(0) { |sum, card| sum + card.value }

    while total > Game::LIMIT && aces_count > 0
      total -= 10
      aces_count -= 1
    end

    total
  end

  def <<(card)
    @hand << card
  end

  def display(hide_card: false)
    split_cards = if hide_card
                    [hand.first.to_s.split("\n"), Card::BACK.split("\n")]
                  else
                    hand.map { |card| card.to_s.split("\n") }
                  end

    0.upto(6) do |idx|
      puts split_cards.map { |card| card[idx] }.join("  ")
    end
  end
end

class Player
  attr_reader :hand, :name, :score

  def initialize(name)
    @name = name
    reset_score
    new_hand
  end

  def reset_score
    @score = 0
  end

  def new_hand
    @hand = Hand.new
  end

  def increment_score
    @score += 1
  end

  def busted?
    hand.total > 21
  end

  def display_hand
    puts "#{name} has:"
    hand.display
  end

  def hand_total
    hand.total
  end

  def display_score
    puts "#{name} has #{hand.total}"
  end

  def <<(card)
    hand << card
  end

  def >(other)
    hand.total > other.hand.total
  end
end

class Human < Player
  include Inputable

  def hit?
    puts "You have #{hand_total}."
    puts "Would you like to (h)it or (s)tay?"
    answer = user_input_choice(%w(h s))
    answer[0] == 'h'
  end
end

class Dealer < Player
  attr_reader :hide

  def new_hand
    @hide = true
    super
  end

  def show_card
    @hide = false
  end

  def hide_card
    @hide = true
  end

  def hit?
    sleep 1.5
    hand.total <= 16
  end

  def display_hand
    puts "#{name} has:"
    hand.display(hide_card: hide)
  end
end

class Game
  include Inputable

  LIMIT = 21
  GOAL_SCORE_RANGE = (1..9)

  def initialize
    @dealer = Dealer.new("Dealer")
    @goal_score = nil
  end

  def play
    set_up_game
    loop do
      set_up_tournament
      play_tournament
      break unless play_another_tournament?
    end
    display_goodbye
  end

  private

  attr_reader :deck, :human, :dealer, :current_player, :goal_score

  RULES_1 = <<~RULES_DOC_1
  * In twenty-one you are playing against the dealer.
  * Each player (including the dealer) is dealt two cards.
  * The goal is to get the score closest to 21 without going over.
  * If you go over 21 you BUST and lose the game.
  RULES_DOC_1

  RULES_2 = <<~RULES_DOC_2
  * Face cards are worth 10 points. Ace are 11 or 1.
  * All others are worth the value printed on them.
  * After the initial two cards are dealt, you can HIT (request another card).
  * You can hit as many times as you want until you bust or decide to STAY.
  * Once you stay it is the dealer's turn.
  RULES_DOC_2

  RULES_3 = <<~RULES_DOC_3
  * The dealer must hit until it has a score of at least 17.
  * The dealer must then stay. If the dealer busts, you win!
  * If no one busts, the player with the highest score wins!
  RULES_DOC_3

  def clear_screen
    system('clear') || system('cls')
  end

  def set_up_game
    display_welcome
    @human = Human.new(input_name)
  end

  def set_up_tournament
    human.reset_score
    dealer.reset_score
    dealer.hide_card
    @current_player = human
    puts
    puts "Press 'r' to read the rules, or any other key to play"
    answer = gets.chomp.downcase
    display_rules if answer == 'r'
    @goal_score = input_goal_score
  end

  def play_tournament
    loop do
      initial_deal
      play_hand
      end_of_hand
      break if tournament_winner
      press_any_key("Press a key to play the next game.")
    end
  end

  def play_another_tournament?
    puts "Would you like to play another tournament? (y/n)"
    answer = user_input_choice(['y', 'n'])
    answer == 'y'
  end

  def initial_deal
    @deck = Deck.new
    human.new_hand
    dealer.new_hand
    @current_player = human

    2.times do
      human << deck.draw_card
      dealer << deck.draw_card
    end
  end

  def play_hand
    2.times do
      clear_and_display_cards
      current_player_turn
      next_player
      dealer.show_card
      break if human.busted?
    end
  end

  def end_of_hand
    clear_and_display_cards
    winner = winning_player
    winner&.increment_score
    display_result
  end

  def tournament_winner
    return human if human.score == goal_score
    return dealer if dealer.score == goal_score
  end

  def display_welcome
    clear_screen
    puts "*****************************"
    puts "*** Welcome to Twenty-One ***"
    puts "*****************************"
    puts
    sleep 1
  end

  def display_rules
    clear_screen
    puts RULES_1
    press_any_key("Press a key")
    clear_screen
    puts RULES_2
    press_any_key("Press a key")
    clear_screen
    puts RULES_3
    press_any_key("Those are the rules. Press any key to play...")
  end

  def display_cards
    dealer.display_hand
    puts
    human.display_hand
    puts
  end

  def clear_and_display_cards
    clear_screen
    display_cards
  end

  def display_player_choice(choice)
    if current_player == human && choice == 'hits'
      adverb = choose_adverb
    end

    print "#{current_player.name} #{adverb}#{choice}"
    puts " on #{current_player.hand_total}"
    puts
  end

  def choose_adverb
    case human.hand_total
    when (LIMIT - 3..LIMIT - 1) then ["insanely ", "crazily "].sample
    when (LIMIT - 6..LIMIT - 4) then ["bravely ", "boldly "].sample
    when (0..LIMIT - 7) then ["smartly ", "wisely "].sample
    end
  end

  def display_result
    display_score
    display_winner
    sleep 1.5
    display_tournament_score
    puts
  end

  def display_busted
    if human.busted?
      puts "#{human.name.upcase} BUSTED!"
      true
    elsif dealer.busted?
      puts "#{dealer.name.upcase} BUSTED!"
      true
    end
  end

  def display_score
    return if display_busted
    puts "Dealer has #{dealer.hand_total}."
    puts "You have #{human.hand_total}."
  end

  def display_winner
    winner = winning_player
    if winner
      puts "#{winner.name} wins!"
    else
      puts "It's a push!"
    end
  end

  def display_tournament_score
    puts
    puts "#{dealer.name} has #{dealer.score}, #{human.name} has #{human.score}."
    tourney_winner = tournament_winner
    if tourney_winner
      puts "#{tourney_winner.name} won the tournament!"
    else
      puts "First player to #{goal_score} wins the tournament."
    end
  end

  def display_goodbye
    clear_screen
    puts
    puts "**************************************************"
    puts "***" + "Goodbye, #{human.name}".center(44) + "***"
    puts "***" + "Thanks for playing Twenty-One!".center(44) + "***"
    puts "**************************************************"
    puts
  end

  def input_goal_score
    low = GOAL_SCORE_RANGE.first
    high = GOAL_SCORE_RANGE.last
    puts
    puts "We will play until a player reaches #{low} to #{high} wins."
    puts "How many wins would you like to play to?"
    @goal_score = user_input_integer(low..high)
  end

  def input_name
    name = nil
    loop do
      print "Please enter your name: "
      name = gets.strip
      break unless name.empty?
      puts "Sorry, you must enter at least one letter or number."
    end
    name
  end

  def next_player
    case current_player
    when human
      @current_player = dealer
    when dealer
      @current_player = human
    end
  end

  def current_player_turn
    loop do
      break unless hit?
      clear_and_display_cards
      break if current_player.busted?
    end
  end

  def hit? # rubocop:disable Metrics/MethodLength
    answer = current_player.hit?
    if answer && current_player.hand_total == LIMIT
      hit_on_limit
      answer = false
    elsif answer
      display_player_choice('hits')
      current_player << deck.draw_card
    else
      display_player_choice('stays')
    end

    sleep 1.5
    answer
  end

  def hit_on_limit
    puts "I can't let you do that, #{human.name}."
    sleep 1.5
    puts "Try reading the rules again."
    sleep 1.5
    puts "#{human.name} stays."
  end

  def winning_player
    if human.busted? then dealer
    elsif dealer.busted? then human
    elsif dealer > human then dealer
    elsif human > dealer then human
    end
  end
end

Game.new.play
require 'pry'
class Card
  include Comparable
  attr_reader :rank, :suit

  RANKS = [2,3,4,5,6,7,8,9,10, "Jack", "Queen", "King", "Ace"]

  def initialize(rank, suit)
    @rank = rank
    @suit = suit
  end

  def to_s
    "#{rank} of #{suit}"
  end

  def <=>(other_card)
    RANKS.index(rank) <=> RANKS.index(other_card.rank)
  end

  def num_rep
    RANKS.index(rank)
  end
end


class Deck
  RANKS = ((2..10).to_a + %w(Jack Queen King Ace)).freeze
  SUITS = %w(Hearts Clubs Diamonds Spades).freeze

  def initialize
    new_deck
  end

  def draw
    new_deck if @deck.empty?
    @deck.pop
  end

  private
  
  def new_deck
    @deck = RANKS.each_with_object([]) do |rank, deck|
      SUITS.each do |suit|
        deck << Card.new(rank, suit)
      end
    end
    @deck.shuffle!
  end
end

class Array
  alias_method :draw, :pop
end

class PokerHand
  include Comparable

  def initialize(cards)
    self.hand = []
    5.times do
      card = cards.draw
      self.hand << card
    end
    hand.sort_by! { |card| card.num_rep }
    self.sequence = hand.map {|card| card.num_rep}
    self.rank_only = hand.map {|card| card.rank}
    self.suit_only = hand.map {|card| card.suit}
  end

  def print
    puts hand
  end

  def evaluate
    case
    when royal_flush?     then 'Royal flush'
    when straight_flush?  then 'Straight flush'
    when four_of_a_kind?  then 'Four of a kind'
    when full_house?      then 'Full house'
    when flush?           then 'Flush'
    when straight?        then 'Straight'
    when three_of_a_kind? then 'Three of a kind'
    when two_pair?        then 'Two pair'
    when pair?            then 'Pair'
    else                       'High card'
    end
  end

  private

  attr_accessor :sequence, :hand, :rank_only, :suit_only

  def royal_flush?
    straight_flush? && self.sequence == [8,9,10,11,12]
  end

  def straight_flush?
    flush? && straight?
  end

  def four_of_a_kind?
    Deck::RANKS.each do |rank|
      return true if rank_only.count(rank) == 4
    end
    false
  end

  def full_house?
    return false if !three_of_a_kind? 
    Deck::RANKS.each do |rank|
      return true if rank_only.count(rank) == 2
    end
    false
  end

  def flush?
    suit_only.uniq.size == 1
  end

  def straight?
    sequence.each_with_index do |rank, idx|
      next if idx == 0
      return false if sequence[idx - 1] != sequence[idx] - 1
    end
    true
  end

  def three_of_a_kind?
    Deck::RANKS.each do |rank|
      return true if rank_only.count(rank) == 3
    end
    false
  end

  def two_pair?
    pairs = 0
    Deck::RANKS.each do |rank|
      pairs += 1 if rank_only.count(rank) == 2
    end
    return true if pairs == 2
    false
  end

  def pair?
    pairs = 0
    Deck::RANKS.each do |rank|
      pairs += 1 if rank_only.count(rank) == 2
    end
    return true if pairs == 1
    false
  end
end
hand = PokerHand.new(Deck.new)
hand.print
puts hand.evaluate

hand = PokerHand.new([
  Card.new(10,      'Hearts'),
  Card.new('Ace',   'Hearts'),
  Card.new('Queen', 'Hearts'),
  Card.new('King',  'Hearts'),
  Card.new('Jack',  'Hearts')
])
puts hand.evaluate == 'Royal flush'

hand = PokerHand.new([
  Card.new(8,       'Clubs'),
  Card.new(9,       'Clubs'),
  Card.new('Queen', 'Clubs'),
  Card.new(10,      'Clubs'),
  Card.new('Jack',  'Clubs')
])
puts hand.evaluate == 'Straight flush'

hand = PokerHand.new([
  Card.new(3, 'Hearts'),
  Card.new(3, 'Clubs'),
  Card.new(5, 'Diamonds'),
  Card.new(3, 'Spades'),
  Card.new(3, 'Diamonds')
])
puts hand.evaluate == 'Four of a kind'

hand = PokerHand.new([
  Card.new(3, 'Hearts'),
  Card.new(3, 'Clubs'),
  Card.new(5, 'Diamonds'),
  Card.new(3, 'Spades'),
  Card.new(5, 'Hearts')
])
puts hand.evaluate == 'Full house'

hand = PokerHand.new([
  Card.new(10, 'Hearts'),
  Card.new('Ace', 'Hearts'),
  Card.new(2, 'Hearts'),
  Card.new('King', 'Hearts'),
  Card.new(3, 'Hearts')
])
puts hand.evaluate == 'Flush'

hand = PokerHand.new([
  Card.new(8,      'Clubs'),
  Card.new(9,      'Diamonds'),
  Card.new(10,     'Clubs'),
  Card.new(7,      'Hearts'),
  Card.new('Jack', 'Clubs')
])
puts hand.evaluate == 'Straight'

hand = PokerHand.new([
  Card.new('Queen', 'Clubs'),
  Card.new('King',  'Diamonds'),
  Card.new(10,      'Clubs'),
  Card.new('Ace',   'Hearts'),
  Card.new('Jack',  'Clubs')
])
puts hand.evaluate == 'Straight'

hand = PokerHand.new([
  Card.new(3, 'Hearts'),
  Card.new(3, 'Clubs'),
  Card.new(5, 'Diamonds'),
  Card.new(3, 'Spades'),
  Card.new(6, 'Diamonds')
])
puts hand.evaluate == 'Three of a kind'

hand = PokerHand.new([
  Card.new(9, 'Hearts'),
  Card.new(9, 'Clubs'),
  Card.new(5, 'Diamonds'),
  Card.new(8, 'Spades'),
  Card.new(5, 'Hearts')
])
puts hand.evaluate == 'Two pair'

hand = PokerHand.new([
  Card.new(2, 'Hearts'),
  Card.new(9, 'Clubs'),
  Card.new(5, 'Diamonds'),
  Card.new(9, 'Spades'),
  Card.new(3, 'Diamonds')
])
puts hand.evaluate == 'Pair'

hand = PokerHand.new([
  Card.new(2,      'Hearts'),
  Card.new('King', 'Clubs'),
  Card.new(5,      'Diamonds'),
  Card.new(9,      'Spades'),
  Card.new(3,      'Diamonds')
])
puts hand.evaluate == 'High card'
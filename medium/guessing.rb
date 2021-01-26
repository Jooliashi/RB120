class GuessingGame

  def initialize(lower, upper)
    @guesses = Math.log2(upper - lower).to_i + 1
    @range = (lower..upper)
    @number = nil
  end 

  def play
    reset
    @guesses.downto(1) do |remaining_guesses|
      display_num_of_guesses(remaining_guesses)
      get_guess
      display_messages
      break if check_answer == 0
    end
    puts "You ran out of guesses, you lost!" unless check_answer == 0
  end

  private
  
  attr_accessor :guesses, :number

  def reset
    @number = rand(@range)
  end

  def display_num_of_guesses(num)
    puts "You have #{num} guesses remaining."
  end

  def display_instruction
    puts "Enter a number between #{@range.first} and #{@range.last}:"
  end

  def get_guess
    display_instruction
    @answer = nil
    loop do
      @answer = gets.chomp.to_i
      break if @range.cover?(@answer)
      puts "Invalid guess. Enter a number between 1 and 100:"
    end
    @answer
  end

  def check_answer
    @answer <=> @number
  end

  def display_messages
    case check_answer
    when -1 then puts "Your guess is too low"
    when 1 then puts "Your guess is too high"
    else   puts "You won!"
    end
  end
end

game = GuessingGame.new(501, 1500)
game.play
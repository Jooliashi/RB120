class Minilang
  def initialize(msg)
    @command = msg
    @stack = []
    @register = 0
  end

  def eval
    begin
      calculate
    rescue InvalidToken => e
      puts e.message
    rescue EmptyStack => e
      puts e.message
    ensure
      @stack = []
      @register = 0
    end
  end

  def calculate
    @command.split.each do |token|
      case token
      when 'ADD'   then @register += @stack.pop
      when 'DIV'   then @register /= @stack.pop
      when 'MULT'  then @register *= @stack.pop
      when 'MOD'   then @register %= @stack.pop
      when 'SUB'   then @register -= @stack.pop
      when 'PUSH'  then @stack.push(@register)
      when 'POP'   then @register = @stack.pop
      when 'PRINT' then puts @register
      when /[[+-]?[0-9]+]/ then @register = token.to_i
      else         raise InvalidToken, "Invalid token: #{token}"
      end

      raise EmptyStack, "Empty stack!" if @register == nil
    end
  end
end 

class InvalidToken < StandardError
end

class EmptyStack < StandardError
end

Minilang.new('5 PRINT PUSH 3 PRINT ADD PRINT').eval
# 5
# 3
# 8

Minilang.new('5 PUSH 10 PRINT POP PRINT').eval
# 10
# 5

Minilang.new('5 PUSH POP POP PRINT').eval
# Empty stack!

Minilang.new('3 PUSH PUSH 7 DIV MULT PRINT ').eval
# 6

Minilang.new('4 PUSH PUSH 7 MOD MULT PRINT ').eval
# 12

Minilang.new('-3 PUSH 5 XSUB PRINT').eval
# Invalid token: XSUB

Minilang.new('-3 PUSH 5 SUB PRINT').eval
# 8

Minilang.new('6 PUSH').eval
# (nothing printed; no PRINT commands)

=begin
alternative solutions
require 'set'

class MinilangError < StandardError; end
class BadTokenError < MinilangError; end
class EmptyStackError < MinilangError; end

class Minilang
  ACTIONS = Set.new %w(PUSH ADD SUB MULT DIV MOD POP PRINT)

  def initialize(program)
    @program = program
  end

  def eval
    @stack = []
    @register = 0
    @program.split.each { |token| eval_token(token)}
  rescue MinilangError => error
    puts error.message
  end

  private

  def eval_token(token)
    if ACTIONS.include?(token)
      send(token.downcase)
    elsif token =~ /\A[-+]?\d+\z/
      @register = token.to_i
    else
      raise BadTokenError, "Invalid token: #{token}"
    end
  end

  def push
    @stack.push(@register)
  end

  def pop
    raise EmptyStackError, "Empty stack!" if @stack.empty?
    @register = @stack.pop
  end

  def add
    @register += pop
  end

  def div
    @register /= pop
  end

  def mod
    @register %= pop
  end

  def mult
    @register *= pop
  end

  def sub
    @register -= pop
  end

  def print
    puts @register
  end
end
=end
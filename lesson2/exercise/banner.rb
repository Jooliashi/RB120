class Banner
  
  def initialize(message, width = message.length + 4)
    @message = message
    if width < message.length 
      puts "invalid input, the width is now assigned to it's minimum possible"
      @width = message.length + 4
    else  
      @width = width  
    end 
  end

  def to_s
    [horizontal_rule, empty_line, message_line, empty_line, horizontal_rule].join("\n")
  end

  private

  def horizontal_rule
    "+" + "-" * (@width - 2) + "+"
  end

  def empty_line
    "|" + " " * (@width - 2) + "|"
  end

  def message_line
    "|" + @message.center(@width - 2) + "|"
  end
end

banner = Banner.new('To boldly go where no one has gone before.', 20)
puts banner

banner = Banner.new('')
puts banner

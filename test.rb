class Animal
  def run
    'running!'
  end

  def jump
    'jumping!'
  end
end

class Cat < Animal
  def speak
    'Meow!'
  end 
end 

class Dog < Animal 
  def fetch
    'fetching!'
  end   

  def swim
    'swimming!'
  end

  def speak
    'bark!'
  end
end 

class Bulldog < Dog
  def swim
    "can't swim!"
  end 
end 

pete = Animal.new
kitty = Cat.new
dave = Dog.new
bud = Bulldog.new

p pete.run                # => "running!"


p kitty.run               # => "running!"
p kitty.speak             # => "meow!"

p dave.speak              # => "bark!"
 
p bud.run                 # => "running!"
p bud.swim                # => "can't swim!"
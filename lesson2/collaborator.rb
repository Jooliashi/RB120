class Person
  attr_accessor :name, :pets

  def initialize(name)
    @name = name 
    @pets = []
  end 
end 

class Bulldog
end 

class Cat
end 

bob = Person.new("Robert")
kitty = Cat.new
bud = Bulldog.new

bob.pets << kitty
bob.pets << bud

puts bob.pets 
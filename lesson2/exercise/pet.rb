require 'pry'
class Pet
  attr_reader :species, :name
  def initialize(species, name)
    @species = species
    @name = name
  end 

  def to_s
    "a #{species} named #{name}"
  end 
end 

class Owner
  attr_reader :name, :number_of_pets
  def initialize(name)
    @name = name
    @number_of_pets = 0
  end 

  def increase_pet
    @number_of_pets += 1
  end 
end 

class Shelter
  attr_reader :unadopted_pets
  def print_all 
    puts "The Animal Shelter has the following unadopted pets: "
    @unadopted_pets.each do |pet|
      puts pet
    end 
  end 

  def add_pet(pet)
    @unadopted_pets << pet 
  end 

  def initialize
    @adoptions = {}
    @unadopted_pets = []
  end 

  def adopt(owner, pet)
    @unadopted_pets.delete(pet)
    if @adoptions.has_key?(owner)
      @adoptions[owner] << pet 
    else 
      @adoptions[owner] = [pet]
    end 
    owner.increase_pet
  end 

  def print_adoptions
    @adoptions.each do |key, value|
      puts "#{key.name} has adopted the following pets:"
      value.each do |pet|
        puts pet
      end 
    end 
  end 
end 

butterscotch = Pet.new('cat', 'Butterscotch')
pudding      = Pet.new('cat', 'Pudding')
darwin       = Pet.new('bearded dragon', 'Darwin')
kennedy      = Pet.new('dog', 'Kennedy')
sweetie      = Pet.new('parakeet', 'Sweetie Pie')
molly        = Pet.new('dog', 'Molly')
chester      = Pet.new('fish', 'Chester')
shelter = Shelter.new
shelter.add_pet(butterscotch)
shelter.add_pet(pudding)
shelter.add_pet(darwin)
shelter.add_pet(kennedy)
shelter.add_pet(sweetie)
shelter.add_pet(molly)
shelter.add_pet(chester)
shelter.print_all
phanson = Owner.new('P Hanson')
bholmes = Owner.new('B Holmes')



shelter.adopt(phanson, butterscotch)
shelter.adopt(phanson, pudding)
shelter.adopt(phanson, darwin)
shelter.adopt(bholmes, kennedy)
shelter.adopt(bholmes, sweetie)
shelter.adopt(bholmes, molly)
shelter.adopt(bholmes, chester)
# shelter.print_adoptions
puts "#{phanson.name} has #{phanson.number_of_pets} adopted pets."
puts "#{bholmes.name} has #{bholmes.number_of_pets} adopted pets."
puts "The Animal shelter has #{shelter.unadopted_pets.size} unadopted pets."
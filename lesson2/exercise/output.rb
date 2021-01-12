class  Pet
  attr_reader :name

  def to_s
    "My name is #{@name.upcase}."
  end

  def initialize(name)
    @name = name.to_s #this is using string class to_s which is different from class pet
  end
end

name = 'Fluffy'
fluffy = Pet.new(name)
puts fluffy.name
puts fluffy
puts fluffy.name
puts name
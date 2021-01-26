module Passenger
  attr_accessor :passenger
  def number_of_passenger(num)
    self.passenger = num
  end
end

class Vehicle
  @@number_of_vehicles = 0

  attr_accessor :color
  attr_reader :model, :year

  def initialize(y, m, c)
    @year = y
    @model = m
    @color = c 
    @current_speed = 0
    @@number_of_vehicles += 1 
  end 

  def self.total_number_of_vehicles 
    @@number_of_vehicles
  end 

  def self.gas_mileage(gallons, miles)
    puts "#{miles / gallons} miles per gallon of gas"
  end 

  def speed_up(num)
    @current_speed += num
    puts "You sped up by #{num} mph"
  end 

  def brake(num)
    @current_speed -= num
    puts "You slowed down by #{num} mph"
  end 

  def shut_off
    @current_speed = 0
    puts "You are parking now"
  end 

  def current_speed
    puts "Your current speed is at #{@current_speed}"
  end 

  def spray_paint(color)
    self.color = color  
    puts "You spray painted your vehicle to #{color}"
  end
  
  def disclose_age 
    puts "Your #{model}'s age is #{age} years"
  end 

  private 

  def age 
    Time.now.year - @year 
  end 
end 

class MyTruck < Vehicle
  NUMBER_OF_DOORS = 4
  def to_s
    "My truck is a #{color} #{model}."
  end 
end 

class MyCar < Vehicle
  include Passenger
  NUMBER_OF_DOORS = 2 
  
  def to_s
    "My car is a #{color} #{year} #{model}."
  end 

end 

class Student
  attr_accessor :name 
  attr_writer :grade 
  
  def initialize(name, grade)
    self.name = name 
    self.grade = grade 
  end 

  def better_grade_than?(student)
    grade > student.grade 
  end  

  protected  

  attr_reader :grade  
end 

bob = Student.new("Bob", 97)
joe = Student.new("Joe", 100)

puts "Well done!" if joe.better_grade_than?(bob)


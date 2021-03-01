# Objected Oriented Programming

a programming paradigm; 

1. Created to deal with complexity of large software systems. 
2. reduce dependencies and facilitate maintenance 
3. greater level of reusability and flexibility
4. objects represented by real-world nouns which helps programmers think at a higher level of abstraction

## Terms

### Encapsulation

Encapsulation means compartmentalizing and containing data and functionality within an object. It enables interaction with objects by exposing their interfaces.

The benefits of encapsulation includes data protection (avoid external unwanted manipulation of data by hiding interfaces), reduce dependencies, and allows coders to think more abstractly by representing objects with real world nouns.

In Ruby, encapsulation is shown in three main ways.

1. Class encapsulate methods

Ruby defines classes which are also objects of the class Class. A class encapsulate methods which are only accessible to objects instantiated from this class or its subclasses. 

For example, last line of code `kitty.bark` will raise a nomethod error since local variable `kitty` is pointing to an object instantiated from class Cat and the object only has access to methods encapsulated in class Cat.

```ruby
#Classes encapsulate methods

class Cat
  def pur
    "purrr"
  end
end

class Dog
  def bark
    "Woof"
  end
end

kitty = Cat.new
kitty.pur 
kitty.bark
```

2. objects encapsulate states

classes instantiate objects which encapsulate their own unique states shown through their instance variables and values assigned to them

two different objects cannot access each other instance variables

```ruby
class Person
  attr_reader :age
  def initialize(age)
    @age = age
  end
end

jake = Person.new(20)
john = Person.new(30)

p jake.age
p john.age
```

3. access control

ruby uses access control to expose/hide interfaces of a method

```ruby
#access control

#private, protected, public

class Person
  def initialize(age)
    @age = age
  end
    
  def show_age
    puts age
  end
    
  def >(other)
    age > other.age
  end
  
  def change_age(new_age)
    self.age = new_age
  end
  
  private
  attr_writer :age
    
  protected
  attr_reader :age
end

jake = Person.new(20)
john = Person.new(30)

p jake > john
jake.show_age
jake.change_age(15)
jake.show_age

```



```ruby
class Game
  def initialize
  end
  
  def play
    rules
  end
  
  def display_winner
    who_wins
  end
  
  private
  
  def rules
  end
  
  def who_wins
  end
  
end
```

### Polymorphism 

polymorphism is using the same interface(methods) for different data types and get different/same results. It allows flexibility for codes where same codes don't need to be repeated but can easily be applied to other parts of programs that needs them. Polymorphism also allows easy maintainability of codes. Because the same code is not repeated, a change made to the code can be applied to all the area that the code is used. 

In Ruby, polymorphism is shown in three ways: class inheritance, interface inheritance and duck typing.

1. in class inheritance, when the same method is called, different subclasses can exhibit same behaviors as superclass by inheriting or exhibit different behaviors by overriding.

```ruby
class Fruit
  def seeds
      "I have seeds"
  end
end
    
class Watermelon < Fruit
end
    
class Banana < Fruit
  def seeds
      "I have no seeds"
  end
end

watermelon = Watermelon.new
banana = Banana.new
some_fruit = Fruit.new
watermelon.seeds
banana.seeds
some_fruit.seeds
```

2. interface inheritance - inherit a collection of behaviors, usually through modules

Ruby uses interface inheritance to share behaviors between objects of classes that don't have a "is-a" relationship. These classes could be unrelated in nature but exhibit similar behaviors.

```ruby
module Dessertable
    def dessert
        "I can be a dessert"
    end
end

class Fruit
  include Dessertable
    
  def seeds
      "I have seeds"
  end
end

class Cake
	include Dessertable
end

cheesecake = Cake.new
cheesecake.dessert
some_fruit.dessert
```

3. duck typing refers to methods that are not tied to any specific classes. Objects from different classes can use the same method call but react in their own ways

- When two or more object types have a method with the same name, we can invoke that method with any of those objects. When we don't care what type of object is calling the method, we're using polymorphism. Often, polymorphism involves inheritance from a common superclass. However, inheritance isn't necessary as we'll see in this assignment.

  

  ```ruby
  def prepare_the_wedding(people)
      people.each {|person| puts person.prepare_the_wedding}
  end
  
  class Chef
    def prepare_the_wedding
      puts "I will cook a banquet"
    end
  end
  
  class Band
    def prepare_the_wedding
      puts "I will play some music"
    end
  end
  
  people = [Chef.new, Band.new]
  prepare_the_wedding(people)
  ```


## Module 

module is a collection of behaviors that is usable in other classes via mixins through `include` method invocation followed by module name vs inheritance.

Module is used when classes are not fit to inherit or share all the methods with their superclasses. so instead they are enabled to have access to a collection of methods due to their exhibiting a specific hehavior.

### Example 1

```ruby
module Speak
    def speak(sound)
        puts sound
    end
end

class Radio
    include Speak
end

class Person
    include Speak
end

siri = Radio.new
radio.speak("Morning news!")
julia = Person.new
julia.speak("Hello!")
```

### Example 2 - namespacing

module can also includes classes that are similar to each other. It's called namespacing. It's so that we can better organize our classes especially when different classes having the same method name.

```ruby 
module Mammal
    class Dog
        def speak(sound)
            p "#{sound}"
        end 
    end 
    
    class Cat
        def say_name(name)
            p "#{name}"
        end 
    end 
end 

buddy = Mammal::Dog.new
kitty = Mammal::Cat.new
buddy.speak('Arf!')
kitty.say_name('kitty')
```

### Example 3 - method container

```ruby 
module Mammal
    ...
        
    def self.some_out_of_place_method(num)
        num ** 2
    end 
end 
```

**we can use `extend Module` to allow a class to module's class methods**

## Objects

- anything that can be said to have a value is an object (methods and blocks are not objects, nor if)
- they are created from classes and defined by classes. Each will contain different information from others
- Ruby defines attributes and behaviors of objects in classes (outline of what objects should be made of and what it should be able to do). 
- objects represented by real-world nouns which helps programmers think at a higher level of abstraction

### Example

```ruby
class GoodDog
end 

sparky = GoodDog.new
```

on line 1, Class `GoodDog` is defined. 

on line 3, variable `sparky` is initiated to an object or instance instantiated from the class `GoodDog`.

The whole process is called instantiation

## Ruby Method lookup chain

Custom class

Module

Object

Kernel

BasicObject

When a method is called in Ruby, Ruby needs a path to help it identify where and in which order should it be looking for that method. Method lookup path is the order in which Ruby will traverse the class hierarchy to look for that method to invoke. If the behavior is defined in any of the classes/modules along that path, then the instance method corresponding to that behavior will be accessible to the objects of the class. Custom classes have a common path of Custom Class, Modules, Object, Kernel, BasciaObject

```ruby
module Speakable
    def speak
        "i speak"
    end
end

module Fightable
end

class Cat
  include Speakable
  include Fightable
end

kitty = Cat.new
kitty.speak
puts Cat.ancestors
```

## Classes

when defining objects, states track attributes for individual objects and behaviors are what they are capable of doing

-  for a specific object in a class, we use instance variables to track their information. Instance variables are scoped at object level 
- but different objects in the same class, contain identical behaviors. These behaviors are defined as instance methods and is scoped at class level 

### Initialize a new object

```ruby
class Person
    def initialize(age, name)
        @age = age
        @name = name
    end 
    
    def speak
        "hi"
    end
end 

class Cat
    def speak
        "meow"
    end
end

julia = Person.new(24, "Julia")
kitty = Cat.new
p julia
puts kitty.speak
puts julia.speak
```

`initialize` gets called when we call on `new`. The `initialize` method is a constructor 

### Instance variable

`@name`.  It attaches to the object instance instantiated.

```ruby 
class GoodDog
    def initialize(name)
        @name = name
    end
end
```

`initialize` method takes a parameter called `name`. Pass argument to the `initialize` method  through `new` method 

`sparky = GoodDog.new("Sparky")`

string "Sparky" is being passed to method `initialize` through `new` method as a parameter and made available to the method as a local variable. It is then assigned to instance variable `@name`.

so the name of `sparky`object is `"Sparky"`. Each object will have unique state.

## Instance Methods

```ruby
class GoodDog
    def initialize(name)
        @name = name
    end
    
    def speak
        "#{@name} says arf!"
    end 
end 

sparky = GoodDog.new("Sparky")
fido = GoodDog.new("Fido")
p sparky.speak
p fido.speak
```

Instance methods are accessible to objects instantiated by that class and its subclasses' objects. When a instance method is called, the method have access to the calling object's instance variables.

### Accessor Methods

+ a getter method

```ruby
def get_name 
    @name
end 
```

Need to create specific methods to access instance variable values 

- setter method

```ruby
def set_name=(name)
    @name = name
end 
```

If we want to change the value of instance variables 

name is the parameter and will be passed in as an argument to method `set_name=`

- abbreviation

`attr_accessor :name`

takes symbol as an argument and uses it to create the method name for the `getter` and `setter` method.

or `attr_reader :name` `attr_writer :name`

`attr_accessor :name, :height, :weight`

<u>if we call method within method, need to use self pr</u>efix 

it allows state of an object to be called or set outside of its class

it allows the flexibility of changing the getter and setter function 



## Class level methods

```ruby
def self.what_am_i
    "I'm a GoodDog class"
end 
```

Class methods are methods we can call directly on the class itself, without having to instantiate any objects.  It is defined with `self` and called by the class

```ruby
class GoodDog
  @@number_of_dogs = 0

  def initialize
    @@number_of_dogs += 1
  end

  def self.total_number_of_dogs
    @@number_of_dogs
  end
end

puts GoodDog.total_number_of_dogs   # => 0

dog1 = GoodDog.new
dog2 = GoodDog.new

puts GoodDog.total_number_of_dogs   # => 2
```



### Class variables

```ruby 
class GoodDog
    @@number_of_dogs = 0
    
    def initialize 
        @@number_of_dogs += 1
    end 
    
    def self.total_number_of_dogs
        @@number_of_dogs 
    end 
end 
puts GoodDog.total_number_of_dogs
dog1 = GoodDog.new
dog2 = GoodDog.new 

puts GoodDog.total_number_of_dogs
```

class variable `@@number_of_dogs`  is initialized to 0, and in constructor, we increment that value by 1.

we can access class variable from within instance methods 

### Constants

access constant from outside `GoodDog::DOG_YEARS`

```ruby 
class GoodDog
    DOG_YEARS = 7
    
    attr_accessor :name, :age
    
    def initialize(n, a)
        self.name = n 
        self.age = a * DOG_YEARS
    end 
end 
sparky = GoodDog.new("Sparky", 4)
puts sparky.age
```

### to_s 

```ruby 
puts sparky	
```

if we call `puts` now, it automatically calls `to_s` on its argument. 

it returns the name of the object's class and an encoding of its object id  

`p sparky` is equal to `puts sparky.inspect`

we can customize and override the original `to_s` by adding that as an instance method 

```ruby 
class GoodDog
    DOG_YEARS = 7
    
    attr_accessor :name, :age
    
    def initialize(n, a)
        @name = n
        @age = a * DOG_YEARS
    end 
    
    def to_s
        "This dog's name is #{name} and it is #{age} in dog years"
    end 
end 
```



## self 

#### using self in instance methods

Use `self` when calling setter methods from within the class. 

`self`, inside of an instance method, references the instance (object) that called the method - the calling object. This is to help distinguish from creating new local variables. But you can call variable directly from instance method because it does not have access

```ruby
class Person
    attr_writer :age
    def initialize(age)
        @age = age
    end
    
    def change_age(new_age)
        self.age = new_age
    end
    
    def what_is_self
        self
    end
end

class GoodDog
    def what_is_self
        self
    end
end

class GoodDog
    puts self
end
```

use setter method as an example

#### using self to define class methods 

`self`, outside of an instance method inside a class, references the class and can be used to define class methods. That is, `def self.a_method` is the same as `def GoodDog.a_method`. Therefore if we were to define a `name` class method, `def self.name=(n)` is the same as `def GoodDog.name=(n)`.

##  Inheritance 

when a class (subclass) inherit behaviors from another class (superclass)

extract common behaviors of different classes and move it to a superclass

```ruby 
class Animal 
    def speak 
        "Hello!"
    end 
end 

class GoodDog < Animal 
    attr_accessor :name
    
    def initialize(n)
        self.name = n
    end 
    def speak
        "#{name} says arf!"
    end 
end 

class Cat < Animal 
end 

sparky = GoodDog.new("Sparky")
paws = Cat.new
puts sparky.speak 
puts paws.speak 
```

`<` signifies inherit

if class and its superclass have the same method, Ruby will look within its class first.

if you do want to look beyond its own class 

```ruby 
class Animal 
    def speak
        "Hello!"
    end 
end 

class GoodDog < Animal 
    def speak 
        super + " from GoodDog class"
    end 
end 

sparky = GoodDog.new
sparky.speak 
```

```ruby 
class Animal 
    attr_accessor :name 
    
    def initialize(name)
        @name = name
    end 
end 

class GoodDog < Animal 
    def initialize(color)
        super 
        @color = color
    end 
end 
bruno = GoodDog.new("brown")
```

*in this case, the argument is forwarded to `super`. `super` passes the `color` argument in the `initialize` defined in the subclass to that of the `Animal` superclass and invoke it.

```ruby
class BadDog < Animal 
    def initialize(age, name)
        super(name)
        @age = age
    end 
end 
BadDog.new(2, "bear")
```

```ruby 
class Animal 
    def initialize 
    end 
end 

class Bear < Animal 
    def initialize(color)
        super()
        @color = color
    end 
end 

bear = Bear.new("black")
```

*if the superclass method has no argument, its safest to call it with a `()` 

if it does have argument, you actually don't have to explicit write the argument needed to be passed in 

### Module vs Inheritance

we can move common methods that are not fit for natural inheritance into modules

```ruby 
module Swimmable
    def swim
        "I'm swimming!"
    end 
end 

class Animal; end 

class Fish < Animal 
    include Swimmable
end 

class Mammal < Animal 
end 

class Cat < Mammal
end 

class Dog < Mammal
    include Swimmable
end 

sparky = Dog.new
neemo = Fish.new
paws = Cat.new

sparky.swim
neemo.swim
paws.swim
```

module inheritance is also called interface inheritance

- you can only subclass from one class but can mix in as many modules as you like
- "is-a" relationship indicates class inheritance; "has-a" relationship mixes in modules 
- you cannot create objects from modules

### Method lookup path 

```ruby
module Walkable 
    def walk
        "I'm walking."
    end 
end 

module Swimmable
    def swim
        "I'm swimming."
    end 
end 

module Climbable 
    def climb
        "I'm climbing."
    end 
end 

class Animal
    include Walkable
    
    def speak
        "I'm an animal and i speak!"
    end
end

puts "---Animal method lookup---"
puts Animal.ancestors
```

The path is Animal first before module 

```ruby
class GoodDog < Animal 
    include Swimmable
    include Climbable
end 

puts "---GoodDog method lookup---"
puts GoodDog.ancestors
```

It looks in GoodDog first. Then the modules in GoodDog in the order of the last included modules first.

*it's important if we include two modules with the same names 

It will also look up the superclass and then its modules 

*if superclass and subclass has the same modules, it will ignore the one in subclass and only look into it in the superclass 

### Method Access Control

use access modifies to allow or restrict access to, most of the times, methods defined in a class

at the moment, everything we have defined in the class is public methods. Anyone who knows the class name or the object's name can use it.

initialize is always private 

#### Private methods 

`private` is called in the program and anything below it is private

```ruby 
class GoodDog
    DOG_YEARS = 7
    
    attr_accessor :name, :age
    
    def initialize(n, a)
        self.name = n
        self.age = a
    end 
    
    def public_disclosure
        "#{self.name} in human years is #{human_years}"
	end
    
    private 
    
    def human_years
        age * DOG_YEARS
    end 
end 

sparky = GoodDog.new("Sparky", 4)
sparky.human_years
```

The code will throw an error because human_years cannot be used outside of the class definition

so we can use the method inside class definition and construct another method using it to disclose the returned value. 

#### protected methods - same as private?

protected methods acts as public methods within the class but cannot be called outside of the class 

```ruby 
class Animal 
    def a_public_method
        "Will this work? " + a_protected_method 
    end 
    
    protected
    
    def a_protected_method 
        "Yes, I'm protected!"
    end 
end 

fido = Animal.new
fido.a_public_method
    
```

### Accidental Method Overriding

```ruby 
class Parent
    def say_hi
        p "Hi from Parent"
    end 
end 

class Child
    def say_hi
        p "Hi from Child"
    end 
    
    def send
        p "send from Child..."
    end 
end 

son = Child.new
son.send :say_hi
```

here it will give an error message of wrong arguments. Because the method called is `Child` send method which takes no arguments.

```ruby
class Parent
    def say_hi
        p "Hi from Parent"
    end 
end 

class Child
    def say_hi
        p "Hi from Child"
    end 
    
    def instance_of?
        p "I am a fake instance"
    end 
end 

son = Child.new
son.instance_of? Child 
```

again wrong number of arguments 

## Collaborator objects

classes group common behaviors and objects encapsulate state. The object state is saved in an object's instance variables, and that instance variables can hold any objects.

Those objects stored as states are "collaborator objects" because they work in conjunction with the class they are associated with. They have a relationship of association.

The instantiation of the collaborator objects can occur in the definition itself but can also be called later on in the methods.

The class can call on the methods available to collaborator objects's own class through the collaborator objects.

collaborator association should exist upon design even though the instantiation can occur after initiation



Objects that are stored as state within another object.

```ruby 
class Person
  attr_accessor :name, :pet

  def initialize(name, pet)
    @name = name 
    @pet = pet
  end 
  
  def a_stroll
      puts "I'm #{name}, and I'm taking #{pet.name} on a stroll"
  end
end 

class Pomeranian
  attr_reader :name
    def initialize(name)
        @name = name
    end
end 

ore = Pomeranian.new("ore")
bob = Person.new("Robert", ore)

bob.a_stroll
```

`bob` has a collaborator object stored in `@pet` variable. We can use `Bulldog` methods by calling on the object stored in `@pet`

## More

### Equivalance

```ruby
str1 == str2
```

are the values within two objects the same?

```ruby
str1 = "something"
str2 = "something"
str1_copy = str1

str1.equal?str2
str1.equal? str1_copy
str2.equal? str1_copy
```

This is asking are the two objects the same? or are the two variables pointing to the same object?

There are three main methods related to equivalence in Ruby `==`, `eql?` `===`

some of them compare the value of objects and others check if the two objects are the same object.

#### The == method

`==` is an instance method available on all objects. It is defined in `BasicObject` class which is the parent class for all classes in Ruby. But how does `==` know what value to compare is due to that each class define the method specifically

default implementation `==` is comparing if same objects, so if want to compare the value instead we can define it ourselves

```ruby
class Person
    attr_accessor :name
    
    def ==(other)
        name == other.name #This is using string ==
    end
end

bob = Person.new
bob.name = "bob"

bob2 = Person.new
bob2.name = "bob"

bob == bob2
```

`45 == 45.00` is calling the `	Integer#==` method on `45` and passing `45.00` in as an argument which is a float. It's comparing two different classes

If we reverse `45.00 == 45`, now we are calling `float#==`method.

`!=` is automatically defined once you define `==`

#### `===`

This is an instance method used explicitly by `case` statement. 

```ruby
case num
when 1..50
	puts... 
```

`Range#===` is called on the range with num passed to it as an argument. It works by asking if the range is a group, would `num` belong in that group

#### Eql?

compare values and if two objects are of the same class

### Scoping Rules

#### Instance variable scopes

scoped at the object level. Instance variables track individual state, and do not cross over between objects.

accessible in object's instance methods even though they are not initialized there

*initialize instance variables within instance methods

```ruby
class Animal
    def initialize(name)
        @name = name
    end
end

class Dog < Animal
    def initialize(name); end
    
    def dog_name
        "bark! bark! #{@name} bark! bark!"
    end
end

teddy = Dog.new("Teddy")
puts teddy.dog_name # => bark! bark! bark! bark!
```

```ruby
module Swim
    def enable_swimming
        @can_swim = true
    end
end

class Dog
    include Swim
	
    def swim
        "swimming!" if @can_swim
    end
end

teddy = Dog.new
teddy.swim
```



#### class variables scopes

all objects share 1 copy of the class variables and can access them through methods

class methods can also access class variables

```ruby
class Person
    @@total_people = 0
    
    def self.total_people 
        @@total_people
    end
    
    def initialize
        @@total_people += 1
    end
    
    def total_people
        @@total_people
    end
end
```

class variable is loaded when the class is evaluated by Ruby. Subclasses can also access it and modify it.

#### Constant Variables scopes

Lexical scope 

```ruby
class Person
    TITLES = ['Mr', 'Mrs', 'Ms', 'Dr']
    
    attr_reader :name
    
    def self.titles
        TITLES.join(', ')
    end
    
    def initialize(n)
        @name = "#{TITLE.sample} #{n}"
    end
end

Person.titles
```

```ruby
class Dog
    LEGS = 4
end

class Cat
    def legs
        Dog::LEGS #namespace resolution operator
    end
end

kitty = Cat.new
kitty.legs
```

mix in modules included 

```ruby
module Maintenance
    def change_tires
        "Changing #{Vehicle::WHEELS} tires"
    end
end

class Vehicle
    WHEELS = 4
end

class Car < Vehicle
    include Maintenance
end

a_car = Car.new
a_car.change_tires 
```

**When you use a method that has been included from a module, Ruby will look for constants starting where that method is defined.**

Constant lookup determines the “current class” differently. Rather than relying on the receiver to determine the current class, *constant lookup starts with the class containing the method*. To be more precise, constant lookup begins its superclass chain search using the class containing the current lexical scope. (If no class is open in the current scope, Ruby starts with the `Object` class.)

### Fake Operators

In ruby some methods look like operators because of the syntactical sugar. Instead of calling the method more normally, we can call it in a natural way like with the `==`

a list of common fake operators include `==` and comparison methods `<` etc

true operators are logical operators `&& ||`, ranges,  assignment and block delimiter

the use of these fake operators mean that we need to be mindful of what 's actually going on

when you create a class, if you call certain methods you thought was operators they might not exist 

However, while you actually implement methods that look like operators to do anything but best to stick to functionality that makes sense

#### The == method

`==` is an instance method available on all objects. It is defined in `BasicObject` class which is the parent class for all classes in Ruby. Default implementation `==` is comparing if same objects, however most subclasses override that function to compare values instead of objects.

`!=` is automatically defined once you define `==`

```ruby
class Person
    attr_accessor :name
    
    def ==(other)
        name == other.name #This is using string ==
    end
end

bob = Person.new
bob.name = "bob"

bob2 = Person.new
bob2.name = "bob"

bob == bob2
```

`45 == 45.00` is calling the `	Integer#==` method on `45` and passing `45.00` in as an argument which is a float. It's comparing two different classes

If we reverse `45.00 == 45`, now we are calling `float#==`method.



#### Comparison methods

```ruby
class Person
    attr_accessor :name, :age
    
    def initialize(name, age)
        @name = name
        @age = age
    end
    
    def >(other_person)
        age > other_person.age
    end
end
```

Even if `>` is created, it does not mean other comparison methods are automatically created

#### `<<` and `>>` shift methods

shift methods are not usually implements except existing collection array use

```ruby
class Team
	attr_accessor :name, :members
    
    def initialize(name)
        @name = name
        @members = []
    end
    
    def <<(person)
        members.push person
    end
end

cowboys = Team.new("Dallas Cowboys")
emmitt = Person.new("Emmitt Smith", 46)

cowboys << emmitt

cowboys.members
```

#### `+` method

either incrementing or concatenation with the argument 

```ruby
class Team
    attr_accessor :name, :members
    
    def initialize(name)
        @name = name
        @members = []
    end
    
    def <<(person)
        members.push person
    end
    
    def +(other_team)
        temp_team = Team.new("Temporary Team")
        temp_team.members = members + other_team.members
        temp_team
    end
end

cowboys = Team.new("Dallas Cowboys")
cowboys << Person.new("Troy Aikman", 48)
cowboys << Person.new("Emmitt Smith", 46)
cowboys << Person.new("Michael Irvin", 49)


niners = Team.new("San Francisco 49ers")
niners << Person.new("Joe Montana", 59)
niners << Person.new("Jerry Rice", 52)
niners << Person.new("Deion Sanders", 47)

dream_team = cowboys + niners 
puts dream_team.inspect
```

#### setter and getter

working with collection

```ruby
class Team
    #...
    
    def [](idx)
        members[idx]
    end
    
    def []=(idx, obj)
        members[idx] = obj
    end
end
```

### Exceptions

an exceptional state in the code, which indicates that your code is behaving unexpectedly.

#### how to handle an exception

##### The begin/rescue block

```ruby
begin
    #code at risk of failing
rescue TypeError, ZeroDivisionError
    #action
rescue ArgumentError
    
end
```

code in `rescue` clause is executed if the code on line `2` raises a `TypeError`. If not exception is raised, the clause will be jumped over and program will continue.

If on line `3`, no type of exception is specified, `StandardError` exceptions will rescued and handled. 

##### Exception Objects and Built-in Methods

```ruby
begin
    #code
rescue StandardError => e
    puts 3.message
end
```

##### ensure

codes that always run at the end of the rescue clauses to ensure some actions are done before program ends

```ruby
file = open(file_name, 'w')

begin
    #do something with the file
rescue
    #handle exception
rescue
    #handle another exception
ensure
    file.close
end
```

##### retry 

directs the block back to the `begin` statement; might be useful to connect to a remote server

best to set number of times you want to `retry`

must be called within the `rescue`block 

```ruby
RETRY_LIMIT = 5

begin 
    attempts = attempts || 0
rescue
    attempts += 1
    retry if attempts < RETRY_LIMIT
end
```

##### Raising exception manually

`raise TypeError.new("Something went wrong!")`

`raise TypeError, "Something went wrong!"`

```ruby
def validate_age(age)
    raise("invalid age") unless (0..105).include?(age)
end
```

```ruby
begin 
    validate_age(age)
rescue RuntimeError => e
    puts e.message
end
```

##### custom exceptions

`class ValidateAgeError < StandardError; end`

always inherit from `StandardError` class otherwise might mask other exceptions 

```ruby
def validate_age(age)
    raise ValidateAgeError, "invalid age" unless (0..105). include?(age)
end

begin 
    validate_age(age)
rescue ValidateAgeError => e
    
end
```

### Random Tips

- how to check and access instance variables

```ruby 
instance.instance_variables
instance.instance_variable.get("@name")
```



- 

# Prep

```ruby
=begin
# 1. Classes and Objects
  - classes are blueprint from which individual objects are created. Classes define attributes and behaviors of the objects they instantiate.
  - objects from the same class share the same behaviors represented by a class' instance methods, but they own their own unique states represented by instance variables along with the values assigned to them when they are initialized.
  -Example showing objects from one class sharing behaviors but having different states.

# 2. Getters and Setters – setters create ivars
# 3. Attr_*
  - getters/setters expose object's instance variables' values 
  - three ways of creating getters and setters
  - benefits of using getter/setters vs manually created methods vs. referencing instance variable directly
    - flexibility of amending the getter/setter methods throughout the class
    
# 4. Instance Methods vs Class Methods
  - Instance methods are scoped at object level. They are shared by all object of the same class or its subclass. They can only be called by an object but not by the class itself. Would be used when we want to expose part of the state of specific objects.
  - class method are scoped at the class level. Can only be called by the class itself without the need to instantiate any objects. Would be used to expose behaviors generic to the entire class. Define prepended with `self`.
  - example: 
    self.what_am_i
    self.num_of_objects_in_this_class
  
# 5. Instance Variable vs Class Variables
  - Instance variables capture information related to specific instances of classes (i.e., objects). class variables are accessed by all objects and behaviors of the entire class, therefore if class variable is reassigned in any class or its subclass, the value of this class variable will reference the last value that it was assigned to. All objects and methods in the class share the same copy of that class variable. Instance variables start with @ and class var starts with @@. 
  - It is limited to the class and its subclasses. The value of class variable can be accessed from the outside through public class or instance methods but the variable itself can only be accessed by the class/its subclass' objects or methods.

class A
  @@class_variable = 0
end

class B < A
  @@class_variable = 1
end

# 6. Inheritance
  -class inheritance (single inheritance) vs. interface inheritance (module mixins)
   -classes can share behavior through inheritance. Subclass can share all the behaviors from its one superclass or choose to override specific methods if it has a behavior different from its superclass objects.
   - classes can also share behaviors through inheriting from modules which are collections of methods. It is done through `include` method call followed by module names.
   class Superclass include module D
   class A does not override
   class B overrides
   module D
   class C unrelated to any other class 
   share module D

# 7. Encapsulation
  -encapsulation compartmentalize data and functionality within the construct of an object, and exposes them through an interface
  -it helps the data to be independent/protected, reduce dependencies, solve problems (real-world nouns)
    #classes encapsulate methods
    #objects encapsulate state
    #access control
    protected: want to evoke method on a explicit caller. another object of the same class
    private: can only call it on the object itself
    
# 8. Polymorphism (objects from different classes calling the same method name)
    #class inheritance
    #interface interitance(modules)
    #duck typing
    - two - three unrelated having the same method name but different behaviors
   class Superclass include module D
   class A does not override
   class B overrides
   module D
   class C unrelated to any other class 
   share module D
   class E
   class F
   [A.new, E.new, F.new].each do |obj|
    obj.method
    end
   
    
# 9. Modules
  - interface inheritance
  - namespacing
  - random method saving

# ***10. Ruby Method Lookup Path
    - why do we use it/why does it exist - tell Ruby where to look for the method
    - what is the path
    - what does super do
    - example of multiple modules path and ancestor path
    - how do we call super(with/without arguments)
    super vs super() vs. super(arg1, arg2)
    super - when subclass and superclass methods have the same arguments
    super() - when superclass has no arguments but subclasses do. Because its shows Ruby that you know there are arguments but you intentionally do not pass them to the superclass
    super(args) - you want to pass in specific arguments only  
    
# 11. Self (2 ways primarily used)
  - return the calling object of this method
  when self is used in instance methods, referring to calling object itself 
  setter method 
  def change_age(new_age)
  self.age = new_age
  end
  
  def what_am_i
  puts self
  end
  
  - create class method
  using self to define class method outside of instance methods. always referring to the class itself
  class Person
  puts self
  
  def self.what_am_i
  puts "i am #{self}"
  end
  
# ***12. Fake Operators && Equality
-methods disguised as operators but they're not built into the syntax of Ruby
-we call them fake operators because we can call them with operator-like syntax
- the == method is avaiable to ALL objects in Ruby
- it's an instance method
- follow conventions/customs in the standard library
- + 

# 13. Truthiness
everything in Ruby is considered to be true / is truthy except `nil` or `false`
if 5
 puts "hi"
else
puts "bye"
end

module A
  def method
    @variable = ''
  end
end

class B
  def another_method
    do this if @variable
  end
  
  def color 
    @color = "blue"
  end
end

B.new.color == nil

# ***14. Collaborator Objects
  -instance variables can be assigned any type of objects and those objects will be considered collaborator objects. They could be either from custom class or pre existing classes in Ruby. The collaborator objects' public methods could be unitilized in collaboration if they are ever called. 
  - example
  an object having two instance variables one is from a standard class other one from custom class

=end
```



## Examples
questions: collaborator objects vs modules

why cannot assign class to VALUES

kitty = Cat.new('Kitty')
p kitty.dye_in_blue

on line `30`, a local variable `kitty` is initialized to an object instantiated from class Cat with string object `Kitty` passed to the constructor as an argument.

on line `22`, an instance variable tracking states of the new object created is assigned to the string object pointed to by the local variable `name` which is `Kitty`. 

on line `31`, method `p` is called on the return value of a instance method call on object referred to by local variable `kitty`. The instance method reads the object's attribute state tracked by its instance variable `@color` which is not assigned to anything at the moment and returns `nil`. Thus the method `p` outputs `nil`

```ruby
class Dog
  attr_reader :name
  def initialize(name)
    @name = name
  end

  def ==(object)
    name == object.name
  end
end

puppy = Dog.new('Benji')
another_puppy = Dog.new('Benji')
p puppy == another_puppy

p puppy
p another_puppy
```

On line 27 the local variable `puppy` is initialize to the object insantiated from the `Dog` class and passed in the string object `'Benji'` as an argument. The argument is passed to the `Dog` classes constructor defined on line 22.

On line 23 its instance variable `@name` is assigned to the object that the local variable `name` is pointing to.

On line 28 the local variable `another_puppy` is initialize to the object instatiated from the `Dog` class and passed in the new string object `'Benji'` as an argument. For this instance variable which tracks the state is also set to `'Benji'` on line 23.

On line 29 the `p` method call is passed in the return value of `puppy == another_puppy". The `==` instance method is called on the puppy object and passed in another_puppy as an argument. The `Dog` class does not have a defined `==` method so based on the ansestory tree the `==` is found which compares the two objects which are different and returns false.

## Questions from quizzes

```ruby
Debug last question
```

State vs attributes

attributes are the properties of a object. They are all the instance variables that are available to an object upon instantiation.

state refer to the values that an object's instance variable holds. Thus two objects from the same class hold same attributes but are at different states 

- The `#initialize` method that initializes a new `Dog` object, which it does by assigning the instance variable `@name` to the dog's name specified by the argument.
- The `#say_hello` instance method which prints a message that includes the dog's name in place of `#{@name}`. `#say_hello` returns `nil`."
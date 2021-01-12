# Objected Oriented Programming

Created to deal with complexity of large software systems. It has ways to contain data so that it can be changed and manipulated without affecting the entire program

## Terms

Encapsulation - hiding pieces of functionality to protect data 

Polymorphism - ability for different types of data to respond to a common interface

Inheritance -  subclasses can inherit behaviors of superclass 

## Module 

a collection of behaviors that is usable in other classes via mixins through `include` method invocation followed by module name

### Example:

```ruby
module Speak
    def speak(sound)
        puts sound
    end
end

class GoodDog
    include Speak
end

class HumanBeing
    include Speak
end

sparky = GoodDog.new
sparky.speak("Arf!")
bob = HumanBeing.new
bob.speak("Hello!")
```



## Objects

- anything that can be said to have a value is an object (methods and blocks are not objects)
- they are created from classes and defined by classes

### Example

```ruby
class GoodDog
end 

sparky = GoodDog.new
```

on line 1, Class `GoodDog` is defined. 

on line 3, variable `sparky` is initiated to an object or instance instantiated from the class `GoodDog`.

### Ruby Method lookup chain

Custom class

Module

Object

Kernel

BasicObject

## Classes

when defining objects, states track attributes for individual objects and behaviors are what they are capable of doing

-  for a specific object in a class, we use instance variables to track their information. Instance variables are scoped at object level 
- but different objects in the same class, contain identical behaviors. These behaviors are defined as instance methods and is scoped at class level 

### Initialize a new object

```ruby
class GoodDog
    def initialize
        puts "This object was initialized!"
    end 
end 
sparky = GoodDog.new 
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

### Instance Methods

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

Instance methods have access to instance variables

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



### Class level methods

```ruby
def self.what_am_i
    "I'm a GoodDog class"
end 
```

for methods that does not need to deal with specific objects and their states

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



### self 

#### using self in instance methods

`self`, inside of an instance method, references the instance (object) that called the method - the calling object. Therefore, `self.weight=` is the same as `sparky.weight=`, in our example.

you can't call `sparky.name=` inside of the class because variable `sparky` is not accessible from inside of the class 

#### using self to define class methods 

`self`, outside of an instance method, references the class and can be used to define class methods. Therefore if we were to define a `name` class method, `def self.name=(n)` is the same as `def GoodDog.name=(n)`.

###  Inheritance 

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
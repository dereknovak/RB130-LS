# RB130 Concepts

## Navigation

- [Closures](#closures)
    - [Blocks/Procs/Lambdas](#blocks-procs-and-lambdas)
    - [Bindings](#binding)
    - [Block Arguments](#block-arguments)
    - [When to use blocks](#when-to-use-blocks)
    - [Returning a closure](#returning-a-closure)
    - [Symbol to Proc](#symbol-to-proc)
    - [Yielding](#yielding)
    - [Arity](#arity)
- [Testing](#testing)
    - [Lanugage](#language)
    - [Minitest vs RSpec](#minitest-vs-rspec)
    - [SEAT](#seat-approach)
    - [Assertions](#assertions)
- [Packaging Code into a Project](#packaging-code-into-a-project)
    - [DSL](#domain-specific-language)
    - [Testing Frameworks]
    - [RubyGems](#rubygems)
    - [Bundler](#bundler)
    - [Gemfile](#gemfile)
    - [Rake](#rake)
    - [Code Coverage](#simplecov-code-coverage)
    - [.gemspec](#gemspec)

# Closures

"A closure is a general programming concept that allows programmers to save a "chunk of code" and execute it at a later time. It's called a "closure" because it's said to bind its surrounding artifacts (ie, names like variables and methods) and build an "enclosure" around everything so that they can be referenced when the closure is later executed."

A closure is a chunk of code, delimited by either `do...end` or `{...}`, that encloses the nearby artifacts as a *binding*, allowing both to be passed around a codebase and executed at a later time.

## Blocks, Procs, and Lambdas

### Block

A block is an anonymous closure that is created at a method invocation and executed within it using the `yield` keyword. Unlike a `Proc` object, blocks are not saved to variables and are executed within the method invocation in which they are arguments.

```ruby
def excited_greet
  puts "#{yield}!!!"
end

excited_greet { "Good morning" }    # Good morning!!!
excited_greet { "Good afternoon" }  # Good afternoon!!!
```

### Proc

A `Proc` object is a saved closure, allowing the "chunk of code" to be passed around a codebase and executed at a later time.

```ruby
greet = Proc.new { puts "Hello World!" }

# Some code stuff...

greet.call
# Hello World!
```

### Lambda

Like a `Proc` object, a `lambda` is a saved closure that can be executed at a later time. Unlike a `Proc`, the `lambda` has strict arity, meaning that if the incorrect number of arguments are passed to it, it will throw an exception.

## Binding

https://launchschool.com/lessons/c0400a9c/assignments/fd86ea2e

"...the Proc keeps track of its surrounding context, and drags it around wherever the chunk of code is passed to. In Ruby, we call this its binding, or surrounding environment/context."

"Note that any local variables that need to be accessed by a closure must be defined before the closure is created, unless the local variable is explicitly passed to the closure when it is called"

When a closure is instantiated, a binding is established at the location of instantiation that keeps track of the surrounding artifacts. This binding is passed alongside the closure, allowing access to any variables or methods within the original scope of the binding. Although the binding allows access to any reassignments occuring after instantiation, local variables must be defined before it to allow the binding access to its pointer.

```ruby
def introduce(proc)
  puts "Introducing the never before seen..."
  puts proc.call
  puts "Get them while they last!"
end

toys = ['Hotwheels', 'Lightsabre']             # Defined before closure
toys_joined = Proc.new { toys.join(' and ') }  # Closure created, binding established
toys = ['GI-Joe', 'Barbie']                    # Reassignment occurs

introduce(toys_joined)
# Introducing the never before seen...
# GI-Joe and Barbie
# Get them while they last!
```

## Block Arguments

### Implicit Blocks

"Every method, regardless of its definition, takes an implicit block. It may ignore the implicit block, but it still accepts it."

All methods, both custom and those within the core Ruby library, have the ability to accept an implicit block. While it may ignore the block completely, the method will continue to function. To check whether or not a block has been provided as an argument, the `block_given?` method can be invoked, evaluating to `true` if a block is present.

```ruby
def a_method
  puts "This will output"
end

a_method { puts "This will not" }
```

### Explicit Blocks

https://launchschool.com/lessons/c0400a9c/assignments/5a060a20

"However, there are times when you want a method to take an explicit block; an explicit block is a block that gets treated as a named object -- that is, it gets assigned to a method parameter so that it can be managed like any other object -- it can be reassigned, passed to other methods, and invoked many times."

"Why do we now need an explicit block instead? Chiefly, the answer is that it provides additional flexibility. Before, we didn't have a handle (a variable) for the implicit block, so we couldn't do much with it except yield to it and test whether a block was provided. Now we have a variable that represents the block, so we can pass the block to another method:"

If a defined method requires a block in order to function, an explicit block can be denoted within the method's parameters. Explicit blocks are represented by a parameter prepended with `&`, which converts the block to a `Proc` object and is called using the `Proc#call` method.

An explicit block allows for greater flexibility of the block within the method. For implicit blocks, we can only really yield to the block and test whether it is present; however, explicit blocks can be renamed, called repeatedly, and can even be passed to methods within the method.

```ruby
def perform_action(block)
  puts "Starting activity"
  block.call
  puts "Activity concluded"
end

def program(&block)
  puts "Opening program"
  perform_action(block)
  puts "Closing program"
end

program { puts "Doing stuff" }
# Opening program
# Starting activity
# Doing stuff
# Activity concluded
# Closing program
```

## When to use blocks

https://launchschool.com/lessons/c0400a9c/assignments/5a060a20

There are 2 primary instances where the implementation of a block is useful within an application:

1. Deferring extended implementation at the time of a method invocation.
2. Incorporating a **sandwich code** structure within a method.

### Defer Implementation

Blocks are useful when the method implementor wants to define a method that allows either themselves or the method user to add an extended element of implementation at the time of the method's invocation. This allows for greater flexibility within the method, as specific details of its implementation can be defined to better suit the needs of the program to which it is utilized.

```ruby
def best_ones(items)
  best_items = []
  items.each do |item|
    best_items << item if yield(item)
  end

  best_items
end

toys = ['bicycle', 'lightsabre', 'barbie', 'lightbike']
best_ones(toys) { |toy| toy =~ /(light)/ }      # => ["lightsabre", "lightbike"]
best_ones(toys) { |toy| toy.start_with?('b') }  # => ["bicycle", "barbie"}
```

### Method Implementor

The method implementor defines a specific method that the method user will interact with throughout the program. They may define all the details of their program or leave specifics up to the users by incorporating blocks yields.

### Method User

The method user interacts with a previously defined method, calling the method on objects throughout the prgram and implementing more specific details through the use of closures.

### Sandwich code

"There will be times when you want to write a generic method that performs some "before" and "after" action. Before and after what? That's exactly the point -- the method implementor doesn't care: before and after anything."

Sandwich code has a common "before" and "after" method execution while leaving the "meat" of the invocation flexible to the specific implementation of the method's user.

Examples:
- Timing, logging, notification systems
- Resource management, or interfacing with the operating system

```ruby
def transform_number(num)
  puts "Before: #{num}"
  new_num = yield(num)
  puts "After: #{new_num}"   
end

transform_number(18) { |num| num + 42 }
# Before: 18
# After: 60
```

## Returning a Closure

"Methods and blocks can return a chunk of code by returning a `Proc` or `lambda`."

Returning a closure from a method or block allows the closure to be called repeatedly, establishing a new binding each iteration which can create a naturally transformative structure. Additionally, multiple Proc object can exist simultaneously, allowing the user keep track of multiple values of similar data.

```ruby
def increment(count = 0)
  Proc.new { count += 1 }
end

num1 = increment
num1.call  # =>  1
num1.call  # =>  2

num2 = increment(10)
num2.call  # =>  11
num2.call  # =>  12

num1.call  # =>  3 (num1 continues)
```
Because a new binding is established upon the instantiation of each `Proc` object, the value referenced by `count` will be different. For example, on line 5 when `num1` is assigned, the `increment` method is first invoked, which has `count` set to `0`. A `Proc` object is instantiated, establishing a new binding which sees the assignment of `count`, then returned from the method, assigning the `Proc` itself to `num1`. When called on line 6, because the `Proc` binding sees `count = 0`, the closure *reassigns* `count` to `1` within this iteration of `increment`. On line 9, a *new* invocation of `increment` is executed, which instantiates a different `Proc` object with a separate binding. Because these 2 bindings exist within separate instances of `increment`, `num2` sees the incrementation of `11` and `12`, while `num1` continues to move to `3` on line 13.

## Symbol to Proc

When prepending a method argument with `&`, Ruby first tries to convert it into a block. If the object is not a `Proc`, Ruby will then try to call the `Symbol#to_proc` method to convert it into a `Proc` so that it can be passed in as a block.

```ruby
def transform(string)
  yield(string)
end

upcase_proc = :upcase.to_proc

transform('hello', &:upcase)      # => "HELLO"
transform('hello', &upcase_proc)  # => "HELLO"
```

## Yielding

"If your method implementation contains a yield, a developer using your method can come in after this method is fully implemented and inject additional code in the middle of this method (without modifying the method implementation), by passing in a block of code."

The `yield` keyword executes the block that has been passed into a method invocation. When passed arguments, the values assigned will be bound to any parameters within the block.

## Arity

"The rule regarding the number of arguments that you must pass to a block, proc, or lambda in Ruby is called its arity."

Arity refers to how a structure handles arguments that are passed into it. Blocks and `Proc` objects contain *lenient arity*, which means that they are not affected with the incorrect number of arguments passed in, whether too few or many. Method and lambdas, conversely, have *strict arity*, which means that they must have the correct amount of arguments, dictated by the parameters, otherwise an `ArgumentError` exception will be thrown.

### Lenient Arity

"In Ruby, blocks and procs have lenient arity, which is why Ruby doesn't complain when you pass in too many or too few arguments to a block."

```ruby
def important_toppings
  yield('pepperoni', 'cheese', 'sausage', 'mushrooms')
end

important_toppings do |topping1, topping2|
  puts "#{topping1} and #{topping2}"
end
# pepperoni and cheese
```

### Strict Arity

"Methods and lambdas, on the other hand, have strict arity, which means you must pass the exact number of arguments that the method or lambda expects."

# Testing

## Language

### Test Suite

"The entire set of tests that accompanies your program or application. You can think of this as *all the tests* for a project."

A test suite is a collection of all of the tests for an application.

### Test

"A situation or context in which tests are run. For example, this test is about making sure you get an error message after trying to log in with the wrong password. A test can contain multiple assertions."

A test is a specific situation of executed code, using a collection of assertions to verify that the codebase is working as intended.

### Assertion

"The actual verification step to confirm that the data returned by your program or application is indeed what you expected. You make one or more assertions within a test."

An assertion is the actual verification step which confirms that the returned data from evaluated code matches the anticipated result.

```ruby
class CarTest < Minitest::Test
  def test_wheels
    car = Car.new
    assert_equal(4, car.wheels)
  end
end
```

- **Test Suite** = `CarTest`
- **Test** = `test_wheels`
- **Assertion** = `assert_equal`

## Minitest vs RSpec

### Miniteset

- Comes installed with Ruby
- Uses normal Ruby syntax
  - Simple to write

Assertion syntax

```ruby
require 'minitest/autorun'

require_relative 'car'

class CarTest < Minitest::Test
  def test_wheels
    car = Car.new
    assert_equal 4, car.wheels
  end
end
```

Expectation syntax

- Uses *expectation matchers* rather than assertions to check the returned data. This reads much more closely to RSpec.

```ruby
require 'minitest/autorun'

require_relative 'car'

describe 'Car#wheels' do
  it 'has 4 wheels' do
    car = Car.new
    _(car.wheels).must_equal 4
  end
end
```

### RSpec

- Does not come installed with Ruby
- A DSL that uses more naturally reading code
  - Difficult to write

## SEAT Approach

https://launchschool.com/lessons/dd2ae827/assignments/5c80633e

```ruby
class CarTest < Minitest::Test
  def setup                 # S
    @car = Car.new
  end

  def test_wheels
    wheels = @car.wheels    # E
    assert_equal 4, wheels  # A
  end

  def teardown              # T
    puts "End of test"
  end
end
```

### S

"Set up the necessary objects."
Set up the objects that will be used throughout testing.

### E

"Execute the code against the object we're testing."
Execute code that will produce a specific result.

### A

"Assert that the executed code did the right thing."
Assert that the executed code produced the expected result.

### T

"Tear down and clean up any lingering artifacts."
Tear down any remaining used throughout testing.

## Assertions

### `assert`

Fails unless its argument evaluates as true.

```ruby
assert 'hello'
```
 
### `assert_equal`

Fails unless the expected return matches the *value* of the actual return.

```ruby
assert_equal 'Bob', Person.new('Bob').name
```

### `assert_same`

Fails unless the expected return matches the *object id* of the actual return.

```ruby
assert_same 4, Car.new.wheels
```

### `assert_nil`

Fails unless its argument returns `nil`.

```ruby
assert_nil puts 'Hello'
```

### `assert_raises`

Fails unless the code executed within its block produces the argument exception.

```ruby
assert_raises(ArgumentError) do
  hash.key?
end
```

### `assert_includes`

Fails unless the provided element is included in the given collection.

```ruby
assert_includes nums, 5
```

### `assert_instance_of`

Fails unless the provided object is an instance of the given class.

```ruby
assert_instance_of String, 'Hello World!'
```

### Refutation

Most assertions contain its oposing counterpart, a **refutation**. These will pass *unless* the refutation matches.

# Packaging Code into a Project

## Domain Specific Language

Domain Specific Language (DSL) is specialized syntax used to write code for a specific application or file. This syntax is typically determined by the program, allowing for greater flexibility and code that reads like natural language.

## Ruby Version Manager

https://launchschool.com/books/core_ruby_tools/read/ruby_version_managers

"Ruby version managers are programs that let you install, manage, and use multiple versions of Ruby."

Because Ruby is a fast-growing programming language that sees periodic updates, different projects may require different versions of Ruby. In order to easily manage the current version of Ruby that your computer uses, a *Ruby Version Manager* can be utilized to quickly install, manage, and switch to the appropriate version of Ruby. The most common Ruby Version Managers employed are **RVM** and **rbenv**.

## RubyGems

https://launchschool.com/books/core_ruby_tools/read/gems

"RubyGems, often just called Gems, are packages of code that you can download, install, and use in your Ruby programs or from the command line."

RubyGems are packages of code that perform a specific task in conjunction with a Ruby program or the command line.

Common gems: pry, rubocope, minitest, bundler, rake

## Bundler

https://launchschool.com/books/core_ruby_tools/read/bundler

"Bundler lets you describe exactly which Ruby and Gems you want to use with your Ruby apps. Specifically, it lets you install multiple versions of each Gem under a specific version of Ruby and then use the proper version in your app."

The **Bundler** RubyGem acts as a dependency manager, allowing the programmer to dictate which version of Ruby and RubyGems their program will use.

### Gemfile

"Bundler relies on a text file named Gemfile to tell it which version of Ruby and its Gems it should use. This file is a simple Ruby program that uses a Domain Specific Language (DSL) to provide details about the Ruby and Gem versions. It's the configuration or instruction file for Bundler."

The `Gemfile` file within a program configures the depenedencies that the application will use. Within this file, the programmer can indicate which version of both Ruby and the included RubyGems that are required, using a Domain Specific Language to include details for each. After all changes have been indicated, the `bundle install` command can be executed within the terminal, creating a `Gemfile.lock` file that includes all of the application's version information

Gemfile
```ruby
source 'https://rubygems.org'

ruby '2.3.1'
gem 'sinatra'
gem 'erubis'
gem 'rack'
gem 'rake'
```

Gemfile.lock
```
GEM
  remote: https://RubyGems.org/
  specs:
    erubis (2.7.0)
    rack (1.6.4)
    rack-protection (1.5.3)
      rack
    rake (10.4.2)
    sinatra (1.4.7)
      rack (~> 1.5)
      rack-protection (~> 1.4)
      tilt (>= 1.3, < 3)
    tilt (2.0.5)

PLATFORMS
  ruby

DEPENDENCIES
  erubis
  rack
  rake
  sinatra

RUBY VERSION
   ruby 2.3.1p112

BUNDLED WITH
   1.13.6
```

### Dependency

"...multiple versions of Ruby and multiple versions of Gems"

### `bundle exec`

"We use it to resolve dependency conflicts when issuing shell commands."

https://launchschool.com/books/core_ruby_tools/read/bundler#bundleexec

Resolve dependency issues

## Rake

https://launchschool.com/books/core_ruby_tools/read/rake

"Rake is a Rubygem that automates many common functions required to build, test, package, and install programs"

Rake is a RubyGem that automates frequently used processes throughout an application project, including the building, testing, packaging, and other repeated tasks of the project.

## SimpleCov (Code Coverage)

https://launchschool.com/lessons/dd2ae827/assignments/9f7c1f7c

"When writing tests, we want to get an idea of code coverage, or how much of our actual program code is tested by a test suite."

"Note that even though we are only testing public code, code coverage is based on all of your code, both public and private. Also, this doesn't mean every edge case is considered, or even that our program is working correctly. It only means that we have some tests in place for every method. "

## .gemspec

"Most Ruby projects use Rubygems as the distribution mechanism. This requires that you observe certain practices when building your project. Specifically, you must use a common directory structure and you must supply a `.gemspec` file."

```
.gemspec
Gem::Specification.new do |s|
  s.name        = 'todolist_project'
  s.version     = '1.0.0'
  s.summary     = 'Todo List Manager!'
  s.description = 'This is a simple todo list manager!'
  s.authors     = ['Pete Williams']
  s.email       = 'pw@example.com'
  s.homepage    = 'http://example.com/todolist_project'
  s.files       = ['lib/todolist_project.rb', 'test/todolist_project_test.rb']
end
```



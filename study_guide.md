# Closures

"A closure is a general programming concept that allows programmers to save a "chunk of code" and execute it at a later time. It's called a "closure" because it's said to bind its surrounding artifacts (ie, names like variables and methods) and build an "enclosure" around everything so that they can be referenced when the closure is later executed."

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

"However, there are times when you want a method to take an explicit block; an explicit block is a block that gets treated as a named object -- that is, it gets assigned to a method parameter so that it can be managed like any other object -- it can be reassigned, passed to other methods, and invoked many times."

If a defined method requires a block in order to function, an explicit block can be denoted within the method's parameters. Explicit blocks are represented by a parameter prepended with `&`, which converts the block to a `Proc` object and is called using the `Proc#call` method.

```ruby
def a_method(&block)
  puts block
end

a_method { 'testing' }
# #<Proc:0x0000000107d69c48 /Users/...>
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

## Sandwich code

"There will be times when you want to write a generic method that performs some "before" and "after" action. Before and after what? That's exactly the point -- the method implementor doesn't care: before and after anything."

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

### Returning a Closure

"Methods and blocks can return a chunk of code by returning a `Proc` or `lambda`."

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

### Symbol to Proc

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

The `yield` keyword executes the block that has been passed into a method invocation.

## Proc

A `Proc` is an unnamed block that can be passed around and called when desired.

## Arity

"The rule regarding the number of arguments that you must pass to a block, proc, or lambda in Ruby is called its arity."

### Lenient Arity

"In Ruby, blocks and procs have lenient arity, which is why Ruby doesn't complain when you pass in too many or too few arguments to a block."

### Strict Arity

"Methods and lambdas, on the other hand, have strict arity, which means you must pass the exact number of arguments that the method or lambda expects."

# Testing

## Language

### Test Suite

"The entire set of tests that accompanies your program or application. You can think of this as *all the tests* for a project."

A test suite is a collection of all the tests for an application.

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

## Bundler

"Bundler lets you describe exactly which Ruby and Gems you want to use with your Ruby apps. Specifically, it lets you install multiple versions of each Gem under a specific version of Ruby and then use the proper version in your app."

### Dependency

"...multiple versions of Ruby and multiple versions of Gems"

### `bundle exec`

"We use it to resolve dependency conflicts when issuing shell commands."

https://launchschool.com/books/core_ruby_tools/read/bundler#bundleexec

## Rake

"Rake is a Rubygem that automates many common functions required to build, test, package, and install programs"
# Study Guide

```ruby
- Blocks
    - Closures, binding, and scope
    - How blocks work, and when we want to use them
    - Blocks and variable scope
    - Create custom methods that use blocks and procs
    - Understand that methods and blocks can return chunks of code (closures)
    - Methods with an explicit block parameter
    - Arguments and return values with blocks
    - When you can pass a block to a method
    - &:symbol
    - Arity of blocks and methods

- Testing
    - Testing terminology
    - Minitest vs. RSpec
    - SEAT approach
    - Testing equality
    - Assertions

- Packaging Code into a Project
    - Purpose of core tools
    - Gemfile

- Coding Challenge
    - You will have access to testing suite
    - Difficulty is an easier medium problem
    - Zero Rubocop complaints
    - Code should pass all tests
    - Double-check previous 2 points before submitting
```

# Questions

# BLOCKS

## 1, What are closures?

## 2, What is binding?

## 3, How does binding affect the scope of closures?

## 4, How do blocks work?

## 5, When do we use blocks? (List the two reasons)

## 6, Describe the two reasons we use blocks, use examples.

## 7, When can you pass a block to a method? Why?

## 8, How do we make a block argument manditory?

## 9, How do methods access both implicit and explicit blocks passed in?

## 10, What is `yield` in Ruby and how does it work?

## 11, How do we check if a block is passed into a method?

## 12, Why is it important to know that methods and blocks can return closures?

```ruby
def sequence
  counter = 0
  Proc.new { counter += 1 }
end

s1 = sequence
p s1.call # 1
p s1.call # 2
p s1.call # 3

s2 = sequence 
p s2.call # 1
p s1.call # 4
p s2.call # 2
```

## 13, What are the benifits of explicit blocks?

## 14, Describe the arity differences of blocks, procs, methods and lambdas.

## 15, What other differences are there between lambdas and procs? (might not be assessed on this, but good to know)

## 16, What does `&` do when in a the method parameter?

```ruby
def method(&var)
  var.call
  yield
end
```

## 17, What does `&` do when in a method invocation argument?

```ruby
method(&var)
```

## 18, What is happening in the code below?

```ruby
arr = [1, 2, 3, 4, 5]

p arr.map(&:to_s) # specifically `&:to_s`

arr.map do |num|
  num.to_s
end

(&:to_s) # => { |num| num.to_s }

a_proc = :to_s.to_proc
p arr.map(&a_proc)
```

## 19, How do we get the desired output without altering the method or the method invocations?

```ruby
def call_this
  yield(2)
end

to_s = Proc.new { |n| n.to_i }
to_i = Proc.new { |n| n.to_s }

p call_this(&to_s) # => returns 2
p call_this(&to_i) # => returns "2"
```

## 20, How do we invoke an explicit block passed into a method using `&`? Provide example.

## 21, What concept does the following code demonstrate?

```ruby
def time_it
  time_before = Time.now
  yield
  time_after= Time.now
  puts "It took #{time_after - time_before} seconds."
end
```

## 22, What will be outputted from the method invocation `block_method('turtle')` below? Why does/doesn't it raise an error?

```ruby
def block_method(animal)
  yield(animal)
end

block_method('turtle', 'seal') do |turtle|
  puts "This is a #{turtle}" #and a #{seal}."
end
```

## 23, What will be outputted if we add the follow code to the code above? Why?

```ruby
animal = 'seal'
block_method('turtle') { puts "This is a #{animal}."}
```


# 24, What will the method call `call_me` output? Why?

```ruby
def call_me(some_code) # Proc
  some_code.call
end

name = "Robert"
chunk_of_code = Proc.new {puts "hi #{name}"}
name = "Griffin"

call_me(chunk_of_code)
```


## 25, What happens when we change the code as such:

```ruby
def call_me(some_code)
  some_code.call
end

chunk_of_code = Proc.new {puts "hi #{name}"}
name = "Griffin"

call_me(chunk_of_code)
```

## 26, What will the method call `call_me` output? Why?

```ruby
def call_me(some_code)
  some_code.call
end

def name
  "Joe"
end

name = "Robert"

chunk_of_code = Proc.new {puts "hi #{name}"}

def name
  "Joe"
end

call_me(chunk_of_code)
```

## 27, Why does the following raise an error?

```ruby
def a_method(pro)
  pro.call
end

a = 'friend'
a_method(&a)
```

## 28, Why does the following code raise an error?

```ruby
def some_method(block)
  block_given?
end

bl = { puts "hi" }

p some_method(bl)
```

## 29, Why does the following code output `false`?

```ruby
def some_method(block)
  block_given?
end

bloc = proc { puts "hi" }

p some_method(bloc)
```

## 30, How do we fix the following code so the output is `true`? Explain

```ruby
def some_method(block)
  block_given? # we want this to return `true`
end

bloc = proc { puts "hi" } # do not alter this code

p some_method(bloc)
```

## 31, How does `Kernel#block_given?` work?

## 32, Why do we get a `LocalJumpError` when executing the below code and how do we fix it so the output is `hi`? (2 possible ways)

```ruby
def some(block)
  yield
end

bloc = proc { p "hi" } # do not alter

some(bloc)
```

## 33, What does the following code tell us about lambda's? (probably not assessed on this but good to know)

```ruby
bloc = lambda { p "hi" }

bloc.class # => Proc
bloc.lambda? # => true

new_lam = Lambda.new { p "hi, lambda!" } # => NameError: uninitialized constant Lambda
```

## 34, What does the following code tell us about explicitly returning from proc's and lambda's? (once again probably not assessed on this, but good to know ;)

```ruby
def lambda_return
  puts "Before lambda call."
  lambda {return}.call
  puts "After lambda call."
end

def proc_return
  puts "Before proc call."
  proc {return}.call
  puts "After proc call."
end

lambda_return #=> "Before lambda call."
              #=> "After lambda call."

proc_return #=> "Before proc call."
```

## 35, What will `#p` output below? Why is this the case and what is this code demonstrating?

```ruby
def retained_array
  arr = []
  Proc.new do |el|
    arr << el
    arr
  end
end

arr = retained_array
arr.call('one')
arr.call('two')
p arr.call('three')
```

# TESTING WITH MINITEST

## 36, What is a test suite?

## 37, What is a test?

## 38, What is an assertion?

## 39, What do testing frameworks provide?

## 40, What are the differences of Minitest vs RSpec

## 41, What is Domain Specific Language (DSL)?

## 42, What is the difference of assertion vs refutation methods?

## 43, How does assert_equal compare its arguments?

## 44, What is the SEAT approach and what are its benefits?

## 45, When does setup and tear down happen when testing?

## 46, What is code coverage?

## 47, What is regression testing?

# CORE TOOLS

## 48, What are the purposes of core tools?

## 49, What are RubyGems and why are they useful?

## 50, What are Version Managers and why are they useful?

## 51, What is Bundler and why is it useful?

## 52, What is Rake and why is it useful?

## 53, What constitues a Ruby project?

```ruby
def method_name(&var) # block -> Proc
  var.call
  yield
end

block = Proc.new {puts "this is the proc"}

method_name { puts "this is the block" }

method_name(&block) # Proc -> block
```
# 1, What are closures?

A closure is a "chunk of code" that is passed around an executed at a later time. When a closure is formed, it encloses all of the artifacts within its lexical scope as a *binding*, which is passed along with the closure and allows objects referenced by these artifacts to be accessible to the closure.

# 2, What is binding?

A binding is a enclosure of all the artifacts within the scope where the binding is established. This allows objects referenced by these artifacts to be accessible wherever the binding is passed.

# 3, How does binding affect the scope of closures?

Because a closure establishes a binding when created, the closure's will have access to the artifacts located within the lexical scope of wherever the closure was made. As an example, a block that gets passed into a method invocation will have been created outside of the method, allowing it access to the artifacts located directly outside of the method invocation. This is why blocks can access local variables initialized outside of its structure, but not the other way around.

# 4, How do blocks work?

A block is a closure that is passed into a method invocation and executed using the `yield` keyword within the method definition. Blocks have *lenient arity*, which means that they do not care how many arguments or parameters are established in reference to them, allowing for more flexible usage.

# 5, When do we use blocks? (List the two reasons)

There are 2 primary ways in which blocks are utilized:

1. Deferring some method implementation to when the method is invoked, allowing for more versitility in the method's functionality.

2. Utilizing a *sandwich code* approach, which has a common "before" and "after" method execution while leaving the "meat" of the invocation flexible to the specific implementation of the method's user.

# 6, Describe the two reasons we use blocks, use examples.

There are 2 primary ways in which blocks are utilized:

1. Deferring some method implementation to when the method is invoked, allowing for more versitility in the method's functionality.

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
Here, the `best_ones` method's sole purpose to is select the "best" items from a given collection. What constitutes "best" is left up to the discresion of the method's user. In this case, the first example on line 11 determines the "best" to be a `toy` that includes the string `"light"` which the second on line 12 decides on a `toy` that starts with the letter `"b"`.

2. Utilizing a *sandwich code* approach, which has a common "before" and "after" method execution while leaving the "meat" of the invocation flexible to the specific implementation of the method's user.

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
For this example, the "bread" part of the *sandwich code* includes outputting the "before" and "after" representations of the given `num`. What is decided to do with `num` is decided by the block, which in this case, simply adds `42` to it.

# 7, When can you pass a block to a method? Why?

# 8, How do we make a block argument manditory?

# 9, How do methods access both implicit and explicit blocks passed in?

# 10, What is `yield` in Ruby and how does it work?

# 11, How do we check if a block is passed into a method?

# 12, Why is it important to know that methods and blocks can return closures?

# def sequence
#   counter = 0
#   Proc.new { counter += 1 }
# end

# s1 = sequence
# p s1.call # 1
# p s1.call # 2
# p s1.call # 3

# s2 = sequence 
# p s2.call # 1
# p s1.call # 4
# p s2.call # 2

# 13, What are the benifits of explicit blocks?

# 14, Describe the arity differences of blocks, procs, methods and lambdas.

# 15, What other differences are there between lambdas and procs? (might not be assessed on this, but good to know)

# 16, What does `&` do when in a the method parameter?

# def method(&var)
#   var.call
#   yield
# end

# 17, What does `&` do when in a method invocation argument?

# ```ruby
# method(&var)
# ```

# 18, What is happening in the code below?

# arr = [1, 2, 3, 4, 5]

# p arr.map(&:to_s) # specifically `&:to_s`

# arr.map do |num|
#   num.to_s
# end

# (&:to_s) # => { |num| num.to_s }

# a_proc = :to_s.to_proc
# p arr.map(&a_proc)

# 19, How do we get the desired output without altering the method or the method invocations?


# def call_this
#   yield(2)
# end

# to_s = Proc.new { |n| n.to_i }
# to_i = Proc.new { |n| n.to_s }

# p call_this(&to_s) # => returns 2
# p call_this(&to_i) # => returns "2"


# 20, How do we invoke an explicit block passed into a method using `&`? Provide example.

# 21, What concept does the following code demonstrate?

# def time_it
#   time_before = Time.now
#   yield
#   time_after= Time.now
#   puts "It took #{time_after - time_before} seconds."
# end

# 22, What will be outputted from the method invocation `block_method('turtle')` below? Why does/doesn't it raise an error?

# def block_method(animal)
#   yield(animal)
# end

# block_method('turtle', 'seal') do |turtle|
#   puts "This is a #{turtle}" #and a #{seal}."
# end

# 23, What will be outputted if we add the follow code to the code above? Why?

# animal = 'seal'
# block_method('turtle') { 
#  
#   puts "This is a #{animal}."}


# 24, What will the method call `call_me` output? Why?

# def call_me(some_code) # Proc
#   some_code.call
# end

# name = "Robert"
# chunk_of_code = Proc.new {puts "hi #{name}"}
# name = "Griffin"

# call_me(chunk_of_code)


# 25, What happens when we change the code as such:

# ```ruby
# def call_me(some_code)
#   some_code.call
# end

# chunk_of_code = Proc.new {puts "hi #{name}"}
# name = "Griffin"

# call_me(chunk_of_code)
# ```

# 26, What will the method call `call_me` output? Why?


def call_me(some_code)
  some_code.call
end

# def name
#   "Joe"
# end

#name = "Robert"

chunk_of_code = Proc.new {puts "hi #{name}"}

# def name
#   "Joe"
# end

call_me(chunk_of_code)

def name
  "Joe"
end


# 27, Why does the following raise an error?

# ```ruby
# def a_method(pro)
#   pro.call
# end

# a = 'friend'
# a_method(&a)
# ```

# 28, Why does the following code raise an error?

# ```ruby
# def some_method(block)
#   block_given?
# end

# bl = { puts "hi" }

# p some_method(bl)
# ```

# 29, Why does the following code output `false`?

# ```ruby
# def some_method(block)
#   block_given?
# end

# bloc = proc { puts "hi" }

# p some_method(bloc)
# ```

# 30, How do we fix the following code so the output is `true`? Explain

# ```ruby
# def some_method(block)
#   block_given? # we want this to return `true`
# end

# bloc = proc { puts "hi" } # do not alter this code

# p some_method(bloc)
# ```

# 31, How does `Kernel#block_given?` work?

# 32, Why do we get a `LocalJumpError` when executing the below code? &
# How do we fix it so the output is `hi`? (2 possible ways)

# ```ruby
# def some(block)
#   yield
# end

# bloc = proc { p "hi" } # do not alter

# some(bloc)
# ```

# 33, What does the following code tell us about lambda's? (probably not assessed on this but good to know)

# ```ruby
# bloc = lambda { p "hi" }

# bloc.class # => Proc
# bloc.lambda? # => true

# new_lam = Lambda.new { p "hi, lambda!" } # => NameError: uninitialized constant Lambda
# ```

# 34, What does the following code tell us about explicitly returning from proc's and lambda's? (once again probably not assessed on this, but good to know ;)

# ```ruby
# def lambda_return
#   puts "Before lambda call."
#   lambda {return}.call
#   puts "After lambda call."
# end

# def proc_return
#   puts "Before proc call."
#   proc {return}.call
#   puts "After proc call."
# end

# lambda_return #=> "Before lambda call."
#               #=> "After lambda call."

# proc_return #=> "Before proc call."

# ```

# 35, What will `#p` output below? Why is this the case and what is this code demonstrating?

# ```ruby
# def retained_array
#   arr = []
#   Proc.new do |el|
#     arr << el
#     arr
#   end
# end

# arr = retained_array
# arr.call('one')
# arr.call('two')
# p arr.call('three')
# ```

### TESTING WITH MINITEST

# 36, What is a test suite?

# 37, What is a test?

# 38, What is an assertion?

# 39, What do testing frameworks provide?

# 40, What are the differences of Minitest vs RSpec

# 41, What is Domain Specific Language (DSL)?

# 42, What is the difference of assertion vs refutation methods?

# 43, How does assert_equal compare its arguments?

# 44, What is the SEAT approach and what are its benefits?

# 45, When does setup and tear down happen when testing?

# 46, What is code coverage?

# 47, What is regression testing?

### CORE TOOLS

# 48, What are the purposes of core tools?

# 49, What are RubyGems and why are they useful?

# 50, What are Version Managers and why are they useful?

# 51, What is Bundler and why is it useful?

# 52, What is Rake and why is it useful?

# 53, What constitues a Ruby project?


# def method_name(&var) # block -> Proc
#   var.call
#   yield
# end

# block = Proc.new {puts "this is the proc"}

# #method_name { puts "this is the block" }

# method_name(&block) # Proc -> block
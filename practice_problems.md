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

A block can always be passed to a method, even if the method completely ignores it. By default, all methods accept an *implicit block*, which do not need to be defined within the method's parameters. If a block is required by the method, an *explicit block* can be added as a parameter, which requires a block to be passed in. The block is then converted to a `Proc` object upon invocation.

# 8, How do we make a block argument mandatory?

A block can be made mandatory by speciffying an *explicit block* within a method's parameters. An explicit block is prepended with an `&` and converted into a `Proc` object.

# 9, How do methods access both implicit and explicit blocks passed in?

A method can access an implicit block by yielding to it using the `yield` keyword. This "jumps" to the block and executes it. A method can access an explicit block by including it as a parameter, prepending the parameter variable with an `&`. This converts the block to a `Proc` object, which can be called within the method using the `Proc#call` method.

# 10, What is `yield` in Ruby and how does it work?

The `yield` keyword executes the implicit block passed into the method where it is located.

# 11, How do we check if a block is passed into a method?

A method can checked whether a block has been passed into it using the `Kernel#block_given?` method, which returns `true` if an implicit block has been passed into the method.

# 12, Why is it important to know that methods and blocks can return closures?

Returning a closure from a method or block allows the closure to be called repeatedly. This allows a new binding to be established each iteration which can create a naturally tranformative structure. This also allows multiple `Proc` object to exist simultaneously, which can help the user keep track of multiple kinds of similar data.

# 13, What are the benifits of explicit blocks?

An explicit block allows for greater flexibility of the block within the method. For implicit block, we can only really yield to the block and test whether it is present; however, explicit blocks can be renamed, called repeatedly, and can even be passed to methods within the method.

# 14, Describe the arity differences of blocks, procs, methods and lambdas.

Arity refers to how a structure handles arguments that are passed into it. Blocks and `Proc` objects contain *lenient arity*, which means that they are not affected with the incorrect number of arguments passed in, whether too few or many. Method and lambdas, on the other hand, have *strict arity*, which means that they must have the correct amount of arguments, dictated by the parameters, otherwise an `ArgumentError` exception will be thrown.

# 15, What other differences are there between lambdas and procs? (might not be assessed on this, but good to know)

# 16, What does `&` do when in a the method parameter?

```ruby
def method(&var)
  var.call
  yield
end
```

The `&`, when used within a method parameter, denotes an *explicit block*. Upon invocation of the method, the block is then converted into a simple `Proc` object, allowing it to be renamed, called multiple times, and passed around throughout the method definition.

# 17, What does `&` do when in a method invocation argument?

```ruby
method(&var)
```

The `&`, when used within a method argument, converts the `Proc` object into a block before getting passed into a method invocation. If the object is not a `Proc`, Ruby tries to convert it to one using `Symbol#to_proc`, which will throw a `TypeError` exception if not a symbol.

# 18, What is happening in the code below?

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

On line 3, the `map` method is called on local variable `arr` and gets passed `&:to_s` as an argument. Before invocation of the `map` method occurs, the `:to_s` symbol is converted into a `Proc` object by the hidden `to_proc` method. This new `Proc` version of the `to_s` method is then passed into the `map` and called on each element referenced by `arr`, returning and outputting the new transformed array `["1", "2", "3", "4", "5"]`.

Line 5 calls the `map` method on `arr` and passes an implicit `do...end` block as an argument. While we cannot see the inner workings of `map`, it is understood that a loop is formed that iterates through each element of `arr`, yielding the current element to the block, which is converted to a string by invocation of the `to_s` method. This produces the same result as line 3 without the need to convert the symbol to a `Proc`, then to a block first.

The last approach in a similar way to the first example, but manually convert the `:to_s` symbol to a `Proc` before passing it in as an argument to the `map` method invocation. Because `:to_s` is now a `Proc` object referenced by `a_proc`, the `to_proc` method does not need to be called before invocation and the `Proc` can simply be converted directly into a block.

# 19, How do we get the desired output without altering the method or the method invocations?

```ruby
def call_this
  yield(2)
end

to_s = Proc.new { |n| n.to_i }
to_i = Proc.new { |n| n.to_s }

p call_this(&to_s) # => returns 2
p call_this(&to_i) # => returns "2"
```

To fix this code, the `to_s` and `to_i` methods should be represented by a symbol.

# 20, How do we invoke an explicit block passed into a method using `&`? Provide example.

You can invoke the explicit block by using `Proc#call` on the method local variable representing it. This works because the `&` operator converts the block to a simple `Proc` object upon invocation of the method.

```ruby
def a_method(&block)
  block.call
end

a_method { puts "Do the thing" }  # Do the thing
```

# 21, What concept does the following code demonstrate?

```ruby
def time_it
  time_before = Time.now
  yield
  time_after= Time.now
  puts "It took #{time_after - time_before} seconds."
end
```

This example represents **sandwich code**, which has a common "before" and "after" method execution while leaving the "meat" of the invocation flexible to the specific implementation of the method's user. In this case, the current `Time` is recorded both before and after a given block is executed, allowing for flexible implementation of the `time_it` method with a consistent output of the time taken across all invocations of the method.

# 22, What will be outputted from the method invocation `block_method('turtle')` below? Why does/doesn't it raise an error?

```ruby
def block_method(animal)
  yield(animal)
end

block_method('turtle', 'seal') do |turtle|
  puts "This is a #{turtle}" #and a #{seal}."
end
```

This example will throw an `ArgumentError` exception due to the `block_method` *strict arity*. Because methods have strict arity, the number of arguments passed in must match the number of parameters present; in this case, the method requires 1 argument but is provided 2. Although blocks have *lenient arity*, the invocation of the method will still occur and therefore the error will be thrown.


# 23, What will be outputted if we add the follow code to the code above? Why?

```ruby
animal = 'seal'
block_method('turtle') { puts "This is a #{animal}."}
```

Adding this code in place of the previous one will output `This is a seal.`. Although `animal` is passed as an argument to the `yield` and the given block does not have a parameter, the *lenient arity* of the block prevents any issues from arising. Since `animal` is no longer a parameter, the block checks its binding for its value and finds `animal = 'seal'` on the previous line, as this variable was assigned before the block was created, its within the binding's scope, and there were no further assignments before the `block_method` invocation.

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

This example will output `hi Griffin`. When the `Proc` object is instantiated on line 6, a binding is established that encloses its immediate lexical scope. Within this scope, `name` is initialized, then reassigned to `"Griffin"` on the following line. This binding travels with the `Proc` into the `call_me` method invocation, which gets called on its first line. Due to the binding, the `Proc` can see the `name` local variable and see its new value of `"Griffin"` established on line 7; therefore this is value that is output within the string interpolation.

# 25, What happens when we change the code as such:

```ruby
def call_me(some_code)
  some_code.call
end

chunk_of_code = Proc.new {puts "hi #{name}"}
name = "Griffin"

call_me(chunk_of_code)
```

Although `name = "Griffin"` is within the lexical scope where the `Proc` object is instantiated, the binding is established *before* the local variable gets initialized; therefore, when searching for `name` after calling the `Proc` within the `call_me` method, Ruby is unable to find `name` and throws a `NameError` exception.

# 26, What will the method call `call_me` output? Why?

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

A few notable things occur in this example:

- When the `Proc` object is instantiated on line 11, a binding is established that can see the `call_me` method, the `name` method, and the `name` local variable.
- The `name` method is redefined after the binding the simply return `"Joe"`.

When calling the `Proc` object on line 2, because the binding can see both the local variable and method, Ruby is unsure which is being referenced and prioritizes the local variable. The last assignment of it was `"Robert"`, which gets interpolated into the string and outputs `hi Robert`.

# 27, Why does the following raise an error?

```ruby
def a_method(pro)
  pro.call
end

a = 'friend'
a_method(&a)
```

The example above raises a `TypeError` exception due to the the value referenced by `a` being a string object. When the `&` operator is used within a method argument, it will try to convert a `Proc` object to a block. If the object is not a `Proc`, it will then also try `Symbol#to_proc`. Because the string is neither a `Proc` nor a `Symbol`, a `TypeError` exception will be thrown.

# 28, Why does the following code raise an error?

```ruby
def some_method(block)
  block_given?
end

bl = { puts "hi" }

p some_method(bl)
```

This example throws a `SyntaxError` due to attempting to assign a block to local variable `bl`. Unlike a `Proc` object, blocks cannot be assigned to a variable and passed around. Also, even if the `Proc` successfully passes into the method, the `block_given?` method checks for an implicit block. 

# 29, Why does the following code output `false`?

```ruby
def some_method(block)
  block_given?
end

bloc = proc { puts "hi" }

p some_method(bloc)
```

The example outputs `false` because `block_given?` returns false, as no block was passed into the method. Although the `Proc` object appears as a block on line 5, it does function slightly differently than a block would when passed into a method invocation. The `block_given?` method returns `true` only if `yield` would execute a block in the current context, and a method does not yield to a proc using the `yield` keyword.

# 30, How do we fix the following code so the output is `true`? Explain

```ruby
def some_method(block)
  block_given? # we want this to return `true`
end

bloc = proc { puts "hi" } # do not alter this code

p some_method(bloc)
```

# 31, How does `Kernel#block_given?` work?

# 32, Why do we get a `LocalJumpError` when executing the below code? &
# How do we fix it so the output is `hi`? (2 possible ways)

```ruby
def some(block)
  yield
end

bloc = proc { p "hi" } # do not alter

some(bloc)
```

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

# 35, What will `p` output below? Why is this the case and what is this code demonstrating?

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

The `p` method invocation will output `['one', 'two', 'three']`.

On line 9, the returned value of the `retained_array` method invocation is assigned to local variable `arr`. This method returns a `Proc` object, which concatenates the block local variable `el` to the array object referenced by the `retained_array` method local variable `arr`. Because each new proc returned from the method establishes its own binding, `arr` on line 2 will progressively reference `[]`, `['one']`, and `['one', 'two']` for each new binding when calling the proc. Then, after executing the final proc on line 12, its return value, as indicated on line 5, will represent the full `['one', 'two', 'three']`.

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
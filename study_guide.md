## Closures

"A closure is a general programming concept that allows programmers to save a "chunk of code" and execute it at a later time. It's called a "closure" because it's said to bind its surrounding artifacts (ie, names like variables and methods) and build an "enclosure" around everything so that they can be referenced when the closure is later executed."

## Binding

"...the Proc keeps track of its surrounding context, and drags it around wherever the chunk of code is passed to. In Ruby, we call this its binding, or surrounding environment/context."

"Note that any local variables that need to be accessed by a closure must be defined before the closure is created, unless the local variable is explicitly passed to the closure when it is called"

```ruby
def call_me(some_code)
  some_code.call
end

name = "Robert"
chunk_of_code = Proc.new {puts "hi #{name}"}
name = "Griffin III"

call_me(chunk_of_code)  # => "hi Griffin III"
```

## Blocks

### Implicit Blocks

"Every method, regardless of its definition, takes an implicit block. It may ignore the implicit block, but it still accepts it."

```ruby
def a_method
  puts "This will output"
end

a_method { puts "This will not" }
```

### Explicit Blocks

"However, there are times when you want a method to take an explicit block; an explicit block is a block that gets treated as a named object -- that is, it gets assigned to a method parameter so that it can be managed like any other object -- it can be reassigned, passed to other methods, and invoked many times."

When using `&` within a method's parameters, the method *must* take a block as an argument, an **explicit block**.

```ruby
def a_method(&block)
  puts block
end

a_method { 'testing' }
```


### Method Implementor

The method implementor defines a specific method that the method user will interact with throughout the program. They may define all the details of their program or leave specifics up to the users by incorporating blocks yields.

### Method User

The method user interacts with a previously defined method, calling the method on objects throughout the prgram and implementing more specific details through the use of closures.

### Sandwich code

"There will be times when you want to write a generic method that performs some "before" and "after" action. Before and after what? That's exactly the point -- the method implementor doesn't care: before and after anything."

Examples:
- Timing, logging, notification systems
- Resource management, or interfacing with the operating system

```ruby
def time_it
  time_before = Time.now
  # do something
  time_after= Time.now

  puts "It took #{time_after - time_before} seconds."
end
```

### Returning a Closure

"Methods and blocks can return a chunk of code by returning a `Proc` or `lambda`."

```ruby
def sequence
  counter = 0
  Proc.new { counter += 1 }
end

s1 = sequence
p s1.call           # 1
p s1.call           # 2
p s1.call           # 3
puts

s2 = sequence
p s2.call           # 1
p s1.call           # 4 (note: this is s1)
p s2.call           # 2
```

### Symbol to Proc

```ruby
def my_method
  yield(2)
end

a_proc = :to_s.to_proc          # explicitly call to_proc on the symbol
my_method(&a_proc)              # convert Proc into block, then pass block in. Returns "2"
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

# This class represents a todo item and its associated
# data: name and description. There's also a "done"
# flag to show whether this todo item is done.

class TodoList
  attr_accessor :title

  def initialize(title)
    @title = title
    @todos = []
  end

  def add(todo)
    raise TypeError, "Can only add Todo objects" unless todo.is_a?(Todo)
    @todos << todo

  rescue TypeError => e
    puts e.message
  end

  def size
    @todos.size
  end

  def first
    @todos.first
  end

  def last
    @todos.last
  end

  def to_a
    @todos.clone
  end

  def done?
    @todos.all?(&:done?)
  end

  def item_at(idx)
    @todos.fetch(idx)
  end

  def mark_done_at(idx)
    @todos.fetch(idx).done!
  end

  def mark_undone_at(idx)
    @todos.fetch(idx).undone!
  end

  def done!
    @todos.each(&:done!)
  end

  def shift
    @todos.shift
  end

  def pop
    @todos.pop
  end

  def remove_at(idx)
    @todos.delete(item_at(idx))
  end

  def to_s
    text = "---- #{title} ----\n"
    text << @todos.map(&:to_s).join("\n")
    text
  end

  def each
    @todos.each { |todo| yield(todo) }
    self
  end

  def select
    new_list = TodoList.new(title)
    @todos.select { |todo| yield(todo) }.each { |todo| new_list.add(todo) }
    new_list
  end
end

class Todo
  DONE_MARKER = 'X'
  UNDONE_MARKER = ' '

  attr_accessor :title, :description, :done

  def initialize(title, description='')
    @title = title
    @description = description
    @done = false
  end

  def done!
    self.done = true
  end

  def done?
    done
  end

  def undone!
    self.done = false
  end

  def to_s
    "[#{done? ? DONE_MARKER : UNDONE_MARKER}] #{title}"
  end

  def ==(otherTodo)
    title == otherTodo.title &&
      description == otherTodo.description &&
      done == otherTodo.done
  end
end

todo1 = Todo.new("Buy milk")
todo2 = Todo.new("Clean room")
todo3 = Todo.new("Go to gym")

list = TodoList.new("Today's Todos")
list.add(todo1)
list.add(todo2)
list.add(todo3)

todo1.done!

results = list.select { |todo| todo.done? }    # you need to implement this method

puts results.inspect
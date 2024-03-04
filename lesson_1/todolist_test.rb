require 'minitest/autorun'
require "minitest/reporters"
Minitest::Reporters.use!

require_relative 'todolist'

class TodoListTest < Minitest::Test
  def setup
    @todo1 = Todo.new("Buy milk")
    @todo2 = Todo.new("Clean room")
    @todo3 = Todo.new("Go to gym")
    @todos = [@todo1, @todo2, @todo3]

    @list = TodoList.new("Today's Todos")
    @list.add(@todo1)
    @list.add(@todo2)
    @list.add(@todo3)
  end

  def test_to_a
    assert_equal(@todos, @list.to_a)
  end

  def test_size
    assert_equal(3, @list.size)
  end

  def test_first
    assert_equal(@todo1, @list.first)
  end

  def test_last
    assert_equal(@todo3, @list.last)
  end

  def test_shift
    assert_equal(@todo1, @list.shift)
    assert_equal(2, @list.size)
  end

  def test_pop
    assert_equal(@todo3, @list.pop)
    assert_equal(2, @list.size)
  end

  def test_done?
    assert_equal(false, @list.done?)
  end

  def test_type_error_message
    assert_raises(TypeError) { @list.add(1) }
    assert_raises(TypeError) { @list.add('hi') }
  end

  def test_shovel_adds_todo
    @todo4 = Todo.new("Something random")
    @list << @todo4
    assert_equal(@list.last, @todo4)
  end

  def test_add_method_works
    @todo4 = Todo.new("Something random")
    @list.add(@todo4)
    assert_equal(@list.last, @todo4)
  end

  def test_item_at
    assert_equal(@todo2, @list.item_at(1))
    assert_raises(IndexError) { @list.item_at(10) }
  end

  def test_mark_done_at
    assert_raises(IndexError) { @list.mark_done_at(10) }
    assert_equal(false, @todo2.done?)
    @list.mark_done_at(1)
    assert_equal(true, @todo2.done?)
  end

  def test_mark_undone_at
    assert_raises(IndexError) { @list.mark_undone_at(10) }
    @list.mark_done_at(1)
    assert_equal(true, @todo2.done?)
    @list.mark_undone_at(1)
    assert_equal(false, @todo2.done?)
  end

  def test_done_bang
    assert_equal(false, @todo1.done?)
    assert_equal(false, @todo2.done?)
    assert_equal(false, @todo3.done?)

    @list.done!

    assert_equal(true, @todo1.done?)
    assert_equal(true, @todo2.done?)
    assert_equal(true, @todo3.done?)
  end

  def test_remove_at
    assert_equal(@todos, @list.to_a)
    @list.remove_at(1)
    assert_equal(@todo3, @list.item_at(1))
    assert_raises(IndexError) { @list.remove_at(2) }
  end
end
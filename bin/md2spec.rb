#!/usr/bin/env ruby

def main
  unless ARGV.length == 1
    puts 'example: md2spec.rb sample.md'
    exit
  end

  md_file = ARGV[0]

  st = SpecTree.new
  File.foreach(md_file) do |line|
    st.add(line)
  end

  puts st.to_spec
end

class SpecTree
  def initialize
    @nodes = []
  end

  def add(line)
    node = Node.new(line)

    last_node = @nodes.last
    @nodes << node

    unless last_node.nil?
      if last_node.level < node.level
        last_node.add_child(node)
      elsif last_node.level == node.level
        last_node.parent&.add_child(node)
      else
        close_parent(node)&.add_child(node)
      end
    end
  end

  def to_spec
    @nodes.first.to_spec
  end

  private

  def close_parent(node)
    @nodes.select {|n| n.level < node.level}.last
  end
end

class Node
  attr_accessor :parent, :children

  def initialize(text)
    @text = text
    @parent = nil
    @children = []

    parse
  end

  def add_child(node)
    children << node
    node.parent = self
  end

  def level
    # とりあえず markdown のインデントは4を想定
    @spaces.length / 4
  end

  def to_spec
    [
      indent + converted_text,
      children.map(&:to_spec),
      comment? ? nil : indent + 'end'
    ].flatten.compact.join("\n")
  end

  protected

  def parse
    matched = @text.match(/^([ ]*)-[ ]*((.+):)?[ ]*(.+)$/)
    @spaces = matched[1]
    @symbol = matched[3]
    @body = matched[4]
  end

  def indent
    # spec に書き出すインデントは2
    ' ' * level * 2
  end

  def converted_text
    return "# #{@body}" if comment?

    case @symbol
    when 'd'
      "describe '#{@body}' do"
    when 'c'
      "context '#{@body}' do"
    when 'i'
      "xit '#{@body}' do"
    when 'f'
      "feature '#{@body}', type: :feature do"
    when 's'
      "xscenario '#{@body}' do"
    else
      raise "Invalid symbol '#{@symbol}'"
    end
  end

  def comment?
    @symbol.nil?
  end
end

if $0 == __FILE__ then
  main
end

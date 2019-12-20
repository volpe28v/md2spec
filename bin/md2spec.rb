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
        last_node.children << node
        node.parent = last_node
      elsif last_node.level == node.level
        parent = last_node.parent
        unless parent.nil?
          parent.children << node
          node.parent = parent
        end
      else
        parent = @nodes.select {|n| n.level < node.level}&.last
        unless parent.nil?
          parent.children << node
          node.parent = parent
        end
      end
    end
  end

  def to_spec
    @nodes.first.to_spec
  end
end

class Node
  attr_accessor :text, :parent, :children

  def initialize(text)
    @text = text
    @parent = nil
    @children = []

    parse
  end

  def parse
    matched = @text.match(/^([ ]*)-[ ]*((.+):)?[ ]*(.+)$/)
    @spaces = matched[1]
    @symbol = matched[3]
    @body = matched[4]
  end

  def level
    # とりあえず markdown のインデントは4を想定
    @spaces.length / 4
  end

  def indent
    # spec に書き出すインデントは2
    ' ' * level * 2
  end

  def decorated_text
    case @symbol
    when 'd'
      "describe '#{@body}' do"
    when 'c'
      "context '#{@body}' do"
    when 'i'
      "xit '#{@body}' do"
    else
      "# #{@body}"
    end
  end

  def comment?
    @symbol.nil?
  end

  def to_spec
    [
      indent + decorated_text,
      children.map(&:to_spec),
      comment? ? nil : indent + 'end'
    ].flatten.compact.join("\n")
  end
end

if $0 == __FILE__ then
  main
end
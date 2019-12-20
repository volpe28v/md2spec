def main
  st = SpecTree.new

  File.foreach("sample.md"){|line|
    st.add(line)
  }

  puts st.to_spec

end

class SpecTree
  def initialize
    @nodes = []
  end

  def add(line)
    node = Node.new(line)
    p node.level

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
    @nodes.first.print

  end
end

class Node
  attr_accessor :text, :parent, :children

  def initialize(text)
    @text = text
    @children = []
  end

  def level
    text.match(/^([ ]*-)/)[0].length / 4
  end

  def indent
    ' ' * level * 4
  end

  def decorated_text
    matched = text.match(/^[ ]*-[ ]*((.+):)?[ ]*(.+)$/)

    case matched[2]
    when 'd'
      "describe '#{matched[3]}' do"
    when 'c'
      "context '#{matched[3]}' do"
    when 'i'
      "it '#{matched[3]}' do"
    else
      "# #{matched[3]}"
    end
  end

  def comment?
    matched = text.match(/^[ ]*-[ ]*((.+):)?[ ]*(.+)$/)
    matched[2].nil?
  end

  def print
    [
      indent + decorated_text,
      children.map(&:print),
      comment? ? nil : indent + 'end'
    ].compact
  end
end


main

require 'treetop'

#require File.join(base_path, 'node_extensions.rb')
require './node_extensions'

class Parser
  base_path = File.expand_path(File.dirname(__FILE__))
  Treetop.load(File.join(base_path, 'todoist_query_parser.treetop'))
  #require './todoist_query_parser.rb'
  @@parser = TodoistQueryParser.new

  def self.parse(data)
    tree = @@parser.parse(data)

    if tree.nil?
      raise Exception, "Parse error at offset: #{@@parser.index}"
    end

    #return tree
    return self.clean_tree(tree)
  end

  private

  def self.clean_tree(node)
    if node.class.name == "Treetop::Runtime::SyntaxNode"
      if node.elements.nil? || node.elements.length == 0
	return []
      else
        return node.elements.map{|n| self.clean_tree n}.flatten(1)
      end
    else
      if !node.elements.nil?
	node.elements.replace node.elements.map{|n| self.clean_tree n}.flatten(1)
      end
      return node
    end
  end
end

def dump_tree(indent, node)
  puts "   " * indent + node.to_s
  return if node.elements.nil?
  node.elements.each  {|node| dump_tree 1 + indent, node}
end

#puts Parser.parse("overdue")
#dump_tree 0, Parser.parse("today | today & p1 | 4 days")
#dump_tree 0, Parser.parse("@foobar")
#dump_tree 0, Parser.parse("no labels")
#dump_tree 0, Parser.parse("(overdue) | today")
dump_tree 0, Parser.parse("7 days & @foo | today")
#dump_tree 0, Parser.parse("7 days & 4 days & !@home")

#puts Parser.parse("7 days & !@home").to_s

#puts Parser.clean_tree( Parser.parse("7 days & 4 days & !@home") )

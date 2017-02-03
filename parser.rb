require 'treetop'

#require File.join(base_path, 'node_extensions.rb')
require './node_extensions'

class Parser
  base_path = File.expand_path(File.dirname(__FILE__))
  Treetop.load(File.join(base_path, 'todoist_query_parser.treetop'))
  @@parser = TodoistQueryParser.new

  def self.parse(data)
    tree = @@parser.parse(data)

    if tree.nil?
      raise Exception, "Parse error at offset: #{@@parser.index}"
    end
    
    return tree
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
dump_tree 0, Parser.parse("no labels")

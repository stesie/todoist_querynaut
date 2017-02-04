module TodoistQuerynaut
  class Parser
    Treetop.load(File.join(File.dirname(__FILE__), 'todoist_query_parser.treetop'))
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
	  return node.elements[0] if node.elements.length == 1 && (node.is_a?(TodoistQuery::Union) || node.is_a?(TodoistQuery::Intersection))
	end
	return node
      end
    end
  end
end

module TodoistQuerynaut
  module TodoistQuery
    class SetExpressionNode < Treetop::Runtime::SyntaxNode
      def children
        elements.reject{|a| a.class.name == 'Treetop::Runtime::SyntaxNode'}
      end

      def sole?
        children.size == 1
      end
    end

    class Union < SetExpressionNode
      def run_query(todoist)
        children.map{|child| child.run_query todoist}.flatten.uniq{|item| item["id"]}
      end
    end

    class Intersection < SetExpressionNode
    end

    class LiteralQuery < Treetop::Runtime::SyntaxNode
      def value
        text_value
      end

      def run_query(todoist)
        # Todoist doesn't always set "query" on the results, hence we cannot
        # search(value)[value] here, as ruby-todoist-api Gem then assigns "nil"
        # as the hash's key.  Instead we do .first.last, to get the value of the
        # first hash entry
        todoist.query.search(value).first.last.data
      end

    end

    class NDaysQuery < Treetop::Runtime::SyntaxNode
    end

    class PriorityQuery < Treetop::Runtime::SyntaxNode
    end

    class ProjectNameQuery < Treetop::Runtime::SyntaxNode
    end

    class LabelQuery < Treetop::Runtime::SyntaxNode
    end

    class NoLabelsQuery < Treetop::Runtime::SyntaxNode
    end

    class NegatedQuery < Treetop::Runtime::SyntaxNode
    end
  end
end

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
        children.inject [] {|acc,child| acc | (child.run_query todoist)}
      end
    end

    class Intersection < SetExpressionNode
      def run_query(todoist)
        acc = children[0].run_query todoist
        children.drop(1).inject(acc) {|acc,child| acc & (child.run_query todoist)}
      end
    end

    class LiteralQuery < Treetop::Runtime::SyntaxNode
      def value
        text_value
      end

      def run_query(todoist)
        todoist.search(value)
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

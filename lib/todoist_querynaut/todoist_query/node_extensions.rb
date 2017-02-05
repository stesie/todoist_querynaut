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
    end

    class Intersection < SetExpressionNode
    end

    class LiteralQuery < Treetop::Runtime::SyntaxNode
      def value
        text_value
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

require "spec_helper"

describe "#parse" do
  describe "query literals" do
    it "should parse 'today'" do
      tree = TodoistQuerynaut::Parser.parse("today")
      expect(tree).to be_a(TodoistQuerynaut::TodoistQuery::LiteralQuery)
    end

    it "should ignore trailing whitespace" do
      tree = TodoistQuerynaut::Parser.parse("today  ")
      expect(tree).to be_a(TodoistQuerynaut::TodoistQuery::LiteralQuery)
    end

    it "should ignore leading whitespace" do
      tree = TodoistQuerynaut::Parser.parse("  today")
      expect(tree).to be_a(TodoistQuerynaut::TodoistQuery::LiteralQuery)
    end

    it "should parse 'tomorrow'" do
      tree = TodoistQuerynaut::Parser.parse("tomorrow")
      expect(tree).to be_a(TodoistQuerynaut::TodoistQuery::LiteralQuery)
    end

    it "should parse 'overdue'" do
      tree = TodoistQuerynaut::Parser.parse("overdue")
      expect(tree).to be_a(TodoistQuerynaut::TodoistQuery::LiteralQuery)
    end

    it "should parse 'over due'" do
      tree = TodoistQuerynaut::Parser.parse("over due")
      expect(tree).to be_a(TodoistQuerynaut::TodoistQuery::LiteralQuery)
    end

    it "should parse 'view all'" do
      tree = TodoistQuerynaut::Parser.parse("view all")
      expect(tree).to be_a(TodoistQuerynaut::TodoistQuery::LiteralQuery)
    end
  end

  describe "negated queries" do
    it "should parse '!today'" do
      tree = TodoistQuerynaut::Parser.parse("!today")
      expect(tree).to be_a(TodoistQuerynaut::TodoistQuery::NegatedQuery)
      expect(tree.query).to be_a(TodoistQuerynaut::TodoistQuery::LiteralQuery)
    end
  end

  describe "n-days queries" do
    it "should parse '4 days'" do
      tree = TodoistQuerynaut::Parser.parse("4 days")
      expect(tree).to be_a(TodoistQuerynaut::TodoistQuery::NDaysQuery)
      expect(tree.value).to eq(4)
    end

    it "should parse '23 days'" do
      tree = TodoistQuerynaut::Parser.parse("23 days")
      expect(tree).to be_a(TodoistQuerynaut::TodoistQuery::NDaysQuery)
      expect(tree.value).to eq(23)
    end

    it "should parse '42   days'" do
      tree = TodoistQuerynaut::Parser.parse("42   days")
      expect(tree).to be_a(TodoistQuerynaut::TodoistQuery::NDaysQuery)
      expect(tree.value).to eq(42)
    end
  end

  describe "priority queries" do
    it "should parse 'p1'" do
      tree = TodoistQuerynaut::Parser.parse("p1")
      expect(tree).to be_a(TodoistQuerynaut::TodoistQuery::PriorityQuery)
      expect(tree.value).to eq(1)
    end

    it "should parse 'priority 3'" do
      tree = TodoistQuerynaut::Parser.parse("priority 3")
      expect(tree).to be_a(TodoistQuerynaut::TodoistQuery::PriorityQuery)
      expect(tree.value).to eq(3)
    end

    it "should parse 'priority   2'" do
      tree = TodoistQuerynaut::Parser.parse("priority   2")
      expect(tree).to be_a(TodoistQuerynaut::TodoistQuery::PriorityQuery)
      expect(tree.value).to eq(2)
    end
  end

  describe "project name queries" do
    it "should parse 'p:foo'" do
      tree = TodoistQuerynaut::Parser.parse("p:foo")
      expect(tree).to be_a(TodoistQuerynaut::TodoistQuery::ProjectNameQuery)
      expect(tree.value).to eq("foo")
    end

    it "should parse 'p:some_long_project23'" do
      tree = TodoistQuerynaut::Parser.parse("p:some_long_project23")
      expect(tree).to be_a(TodoistQuerynaut::TodoistQuery::ProjectNameQuery)
      expect(tree.value).to eq("some_long_project23")
    end
  end

  describe "label queries" do
    it "should parse '@foo'" do
      tree = TodoistQuerynaut::Parser.parse("@foo")
      expect(tree).to be_a(TodoistQuerynaut::TodoistQuery::LabelQuery)
      expect(tree.value).to eq("foo")
    end

    it "should parse '@rspec'" do
      tree = TodoistQuerynaut::Parser.parse("@rspec")
      expect(tree).to be_a(TodoistQuerynaut::TodoistQuery::LabelQuery)
      expect(tree.value).to eq("rspec")
    end

    it "should parse 'no labels'" do
      tree = TodoistQuerynaut::Parser.parse("no labels")
      expect(tree).to be_a(TodoistQuerynaut::TodoistQuery::NoLabelsQuery)
    end
  end

  describe "logical operations" do
    describe "intersections" do
      it "should support intersections of two labels'" do
        tree = TodoistQuerynaut::Parser.parse("@foo & @bar")
        expect(tree).to be_a(TodoistQuerynaut::TodoistQuery::Intersection)
        expect(tree.children[0]).to be_a(TodoistQuerynaut::TodoistQuery::LabelQuery)
        expect(tree.children[0].value).to eq("foo")
        expect(tree.children[1]).to be_a(TodoistQuerynaut::TodoistQuery::LabelQuery)
        expect(tree.children[1].value).to eq("bar")
      end

      it "should support intersections of two different query parts'" do
        tree = TodoistQuerynaut::Parser.parse("@foo & today")
        expect(tree).to be_a(TodoistQuerynaut::TodoistQuery::Intersection)
        expect(tree.children.size).to eq(2)
        expect(tree.children[0]).to be_a(TodoistQuerynaut::TodoistQuery::LabelQuery)
        expect(tree.children[0].value).to eq("foo")
        expect(tree.children[1]).to be_a(TodoistQuerynaut::TodoistQuery::LiteralQuery)
        expect(tree.children[1].value).to eq("today")
      end


      it "should support intersections of multiple parts" do
        tree = TodoistQuerynaut::Parser.parse("@foo & @bar & @here & @there")
        expect(tree).to be_a(TodoistQuerynaut::TodoistQuery::Intersection)
        expect(tree.children.size).to eq(4)
        tree.children.each { |node| expect(node).to be_a(TodoistQuerynaut::TodoistQuery::LabelQuery) }
      end
    end

    describe "unions" do
      it "should support unions of two labels'" do
        tree = TodoistQuerynaut::Parser.parse("@foo | @bar")
        expect(tree).to be_a(TodoistQuerynaut::TodoistQuery::Union)
        expect(tree.children[0]).to be_a(TodoistQuerynaut::TodoistQuery::LabelQuery)
        expect(tree.children[0].value).to eq("foo")
        expect(tree.children[1]).to be_a(TodoistQuerynaut::TodoistQuery::LabelQuery)
        expect(tree.children[1].value).to eq("bar")
      end

      it "should support unions of two different query parts'" do
        tree = TodoistQuerynaut::Parser.parse("@foo | today")
        expect(tree).to be_a(TodoistQuerynaut::TodoistQuery::Union)
        expect(tree.children.size).to eq(2)
        expect(tree.children[0]).to be_a(TodoistQuerynaut::TodoistQuery::LabelQuery)
        expect(tree.children[0].value).to eq("foo")
        expect(tree.children[1]).to be_a(TodoistQuerynaut::TodoistQuery::LiteralQuery)
        expect(tree.children[1].value).to eq("today")
      end

      it "should support unions of multiple parts" do
        tree = TodoistQuerynaut::Parser.parse("@foo | @bar | @here | @there")
        expect(tree).to be_a(TodoistQuerynaut::TodoistQuery::Union)
        expect(tree.children.size).to eq(4)
        tree.children.each { |node| expect(node).to be_a(TodoistQuerynaut::TodoistQuery::LabelQuery) }
      end
    end

    describe "operator precedence" do
      it "should give higher precedence to intersection" do
        tree = TodoistQuerynaut::Parser.parse("p1 & p1 | p4")
        expect(tree).to be_a(TodoistQuerynaut::TodoistQuery::Union)
        expect(tree.children[0]).to be_a(TodoistQuerynaut::TodoistQuery::Intersection)
      end

      it "should give higher precedence to intersection (2)" do
        tree = TodoistQuerynaut::Parser.parse("p4 | p1 & p1")
        expect(tree).to be_a(TodoistQuerynaut::TodoistQuery::Union)
        expect(tree.children[1]).to be_a(TodoistQuerynaut::TodoistQuery::Intersection)
      end

      it "should give even higher precedence to parentheses" do
        tree = TodoistQuerynaut::Parser.parse("p1 & (p1 | p4)")
        expect(tree).to be_a(TodoistQuerynaut::TodoistQuery::Intersection)
        expect(tree.children[1]).to be_a(TodoistQuerynaut::TodoistQuery::Union)
      end

      it "should give even higher precedence to parentheses (2)" do
        tree = TodoistQuerynaut::Parser.parse("(p1 | p4) & p2")
        expect(tree).to be_a(TodoistQuerynaut::TodoistQuery::Intersection)
        expect(tree.children[0]).to be_a(TodoistQuerynaut::TodoistQuery::Union)
      end
    end

  end
end

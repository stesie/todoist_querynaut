require "spec_helper"

describe "#parse" do
  describe "query literals" do
    it "should parse 'today'" do
      tree = TodoistQuerynaut::Parser.parse("today")
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
      expect(tree.elements[0]).to be_a(TodoistQuerynaut::TodoistQuery::LiteralQuery)
    end
  end

  describe "n-days queries" do
    it "should parse '4 days'" do
      tree = TodoistQuerynaut::Parser.parse("4 days")
      expect(tree).to be_a(TodoistQuerynaut::TodoistQuery::NDaysQuery)
      expect(tree.days).to eq(4)
    end
  end


end

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
end

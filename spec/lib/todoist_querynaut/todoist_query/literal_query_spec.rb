require "spec_helper"

describe TodoistQuerynaut::TodoistQuery::LiteralQuery do
  before(:each) do
    @literalQuery = TodoistQuerynaut::TodoistQuery::LiteralQuery.new("today", 0...5)
  end

  describe "#value" do
    it "should return the literal query string" do
      expect(@literalQuery.value).to eq("today")
    end
  end

  describe "#get_query" do
    it "should return the literal query string" do
      expect(@literalQuery.get_query).to eq("today")
    end
  end
end

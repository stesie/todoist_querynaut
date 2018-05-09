require "spec_helper"

describe TodoistQuerynaut::TodoistQuery::LiteralQuery do
  describe "#value" do
    it "should return the literal query string 'today'" do
      literal_query = TodoistQuerynaut::TodoistQuery::LiteralQuery.new("today", 0...5)
      expect(literal_query.value).to eq("today")
    end

    it "should return the literal query string 'overdue'" do
      literal_query = TodoistQuerynaut::TodoistQuery::LiteralQuery.new("overdue", 0...7)
      expect(literal_query.value).to eq("overdue")
    end
  end

  describe "#run_query" do
    it "should run a 'today' query" do
      literal_query = TodoistQuerynaut::TodoistQuery::LiteralQuery.new("today", 0...5)

      stub_request(:post, "https://todoist.com/API/v7/query").
        with(:body => {"queries" => "[\"today\"]", "token" => "some_token"}).
        to_return(:status => 200, :body => json_response_raw("query_today"), :headers => {})
      result = literal_query.run_query TodoistQuerynaut::Client.new(Todoist::Client.new("some_token"))

      expect(result.size).to eq(1)
      expect(result[0]["content"]).to eq("query_today_item_content")
    end

    it "should run a 'overdue' query" do
      literal_query = TodoistQuerynaut::TodoistQuery::LiteralQuery.new("overdue", 0...7)

      stub_request(:post, "https://todoist.com/API/v7/query").
        with(:body => {"queries" => "[\"overdue\"]", "token" => "some_token"}).
        to_return(:status => 200, :body => json_response_raw("query_overdue"), :headers => {})
      result = literal_query.run_query TodoistQuerynaut::Client.new(Todoist::Client.new("some_token"))

      expect(result.size).to eq(2)
      expect(result[0]["content"]).to eq("overdue_one")
      expect(result[1]["content"]).to eq("overdue_two")
    end
  end
end

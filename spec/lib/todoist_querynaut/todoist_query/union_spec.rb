require "spec_helper"

describe TodoistQuerynaut::TodoistQuery::Union do
  describe "#run_query" do
    it "should run both queries and return the union" do
      union_query = TodoistQuerynaut::TodoistQuery::Union.new("today|overdue", 0...13, [
        TodoistQuerynaut::TodoistQuery::LiteralQuery.new("today", 0...5),
        TodoistQuerynaut::TodoistQuery::LiteralQuery.new("overdue", 0...7)
      ])

      stub_request(:post, "https://todoist.com/API/v6/query").
        with(:body => {"queries" => "[\"today\"]", "token" => "some_token"}).
        to_return(:status => 200, :body => json_response_raw("query_today"), :headers => {})
      stub_request(:post, "https://todoist.com/API/v6/query").
        with(:body => {"queries" => "[\"overdue\"]", "token" => "some_token"}).
        to_return(:status => 200, :body => json_response_raw("query_overdue"), :headers => {})
      result = union_query.run_query TodoistQuerynaut::Client.new(Todoist::Client.new("some_token"))

      expect(result.size).to eq(3)
    end

    it "should remove duplicate items" do
      union_query = TodoistQuerynaut::TodoistQuery::Union.new("today|overdue", 0...13, [
        TodoistQuerynaut::TodoistQuery::LiteralQuery.new("today", 0...5),
        TodoistQuerynaut::TodoistQuery::LiteralQuery.new("today", 0...5),
      ])

      stub_request(:post, "https://todoist.com/API/v6/query").
        with(:body => {"queries" => "[\"today\"]", "token" => "some_token"}).
        to_return(:status => 200, :body => json_response_raw("query_today"), :headers => {})
      result = union_query.run_query TodoistQuerynaut::Client.new(Todoist::Client.new("some_token"))

      expect(result.size).to eq(1)
    end
  end
end


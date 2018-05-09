require "spec_helper"

describe TodoistQuerynaut::TodoistQuery::Intersection do
  describe "#run_query" do
    it "should return items of 'today' for 'today & today'" do
      intersection_query = TodoistQuerynaut::TodoistQuery::Intersection.new("today&today", 0...13, [
        TodoistQuerynaut::TodoistQuery::LiteralQuery.new("today", 0...5),
        TodoistQuerynaut::TodoistQuery::LiteralQuery.new("today", 0...5)
      ])

      stub_request(:post, "https://todoist.com/API/v7/query").
        with(:body => {"queries" => "[\"today\"]", "token" => "some_token"}).
        to_return(:status => 200, :body => json_response_raw("query_today"), :headers => {})
      result = intersection_query.run_query TodoistQuerynaut::Client.new(Todoist::Client.new("some_token"))

      expect(result.size).to eq(1)
    end

    it "should run both queries and return the intersection" do
      intersection_query = TodoistQuerynaut::TodoistQuery::Intersection.new("overdue & overdue_one", 0...21, [
        TodoistQuerynaut::TodoistQuery::LiteralQuery.new("overdue", 0...7),
        TodoistQuerynaut::TodoistQuery::LiteralQuery.new("overdue_one", 0...11)
      ])

      stub_request(:post, "https://todoist.com/API/v7/query").
        with(:body => {"queries" => "[\"overdue_one\"]", "token" => "some_token"}).
        to_return(:status => 200, :body => json_response_raw("query_overdue_one"), :headers => {})
      stub_request(:post, "https://todoist.com/API/v7/query").
        with(:body => {"queries" => "[\"overdue\"]", "token" => "some_token"}).
        to_return(:status => 200, :body => json_response_raw("query_overdue"), :headers => {})
      result = intersection_query.run_query TodoistQuerynaut::Client.new(Todoist::Client.new("some_token"))

      expect(result.size).to eq(1)
      expect(result[0]["content"]).to eq("overdue_two")
    end
  end
end

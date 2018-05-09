require "spec_helper"

describe TodoistQuerynaut::TodoistQuery::NegatedQuery do
  describe "#run_query" do
    it "should negate a 'today' query" do
      negated_query = TodoistQuerynaut::Parser.parse("!today")

      # will run two queries: today and "view all"
      stub_request(:post, "https://todoist.com/API/v7/query").
        with(:body => {"queries" => "[\"today\"]", "token" => "some_token"}).
        to_return(:status => 200, :body => json_response_raw("query_today"), :headers => {})
      stub_request(:post, "https://todoist.com/API/v7/query").
        with(:body => {"queries" => "[\"view all\"]", "token" => "some_token"}).
        to_return(:status => 200, :body => json_response_raw("query_view_all"), :headers => {})
      result = negated_query.run_query TodoistQuerynaut::Client.new(Todoist::Client.new("some_token"))

      # all items (4) excluding today (1)  --> 3
      expect(result.size).to eq(3)
    end
  end
end


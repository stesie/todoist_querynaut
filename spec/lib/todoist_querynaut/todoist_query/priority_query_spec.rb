require "spec_helper"

describe TodoistQuerynaut::TodoistQuery::PriorityQuery do
  describe "#value" do
    it "should return the priority of query string 'p4'" do
      priority_query = TodoistQuerynaut::TodoistQuery::PriorityQuery.new("p4", 0...2)
      expect(priority_query.value).to eq(4)
    end

    it "should return the priority of query string 'priority 3'" do
      priority_query = TodoistQuerynaut::TodoistQuery::PriorityQuery.new("priority 3", 0...10)
      expect(priority_query.value).to eq(3)
    end
  end

  describe "#run_query" do
    it "should run a 'p4' query" do
      priority_query = TodoistQuerynaut::TodoistQuery::PriorityQuery.new("p4", 0...2)

      stub_request(:post, "https://todoist.com/API/v6/query").
        with(:body => {"queries" => "[\"p4\"]", "token" => "some_token"}).
        to_return(:status => 200, :body => json_response_raw("query_p4"), :headers => {})
      result = priority_query.run_query TodoistQuerynaut::Client.new(Todoist::Client.new("some_token"))

      expect(result.size).to eq(1)
      expect(result[0]["content"]).to eq("weekly_p4_item")
    end
  end
end


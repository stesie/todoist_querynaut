require "spec_helper"

describe TodoistQuerynaut::Client do
  describe "#search" do
    it "delegates search query to todoist api and returns result" do
      todoist_api = double()
      allow(todoist_api).to receive(:query) {
        query_obj = double()
        allow(query_obj).to receive(:search) { |query|
          { query => Todoist::Result.new({ "query" => "foo", "data" => [ "content_here" ] }) }
        }
        query_obj
      }

      result = TodoistQuerynaut::Client.new(todoist_api).search("foobar")
      expect(result).to eq(["content_here"])
    end
  end

  describe "#all_items" do
    it "should run a 'view all' query" do
      stub_request(:post, "https://todoist.com/API/v6/query").
        with(:body => {"queries" => "[\"view all\"]", "token" => "some_token"}).
        to_return(:status => 200, :body => json_response_raw("query_view_all"), :headers => {})
      result = TodoistQuerynaut::Client.new(Todoist::Client.new("some_token")).all_items

      expect(result.size).to eq(4)
    end
  end
end

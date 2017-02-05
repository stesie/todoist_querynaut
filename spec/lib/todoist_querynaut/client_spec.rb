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
end

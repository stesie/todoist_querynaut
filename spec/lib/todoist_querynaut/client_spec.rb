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
      stub_request(:post, "https://todoist.com/API/v7/query").
        with(:body => {"queries" => "[\"view all\"]", "token" => "some_token"}).
        to_return(:status => 200, :body => json_response_raw("query_view_all"), :headers => {})
      result = TodoistQuerynaut::Client.new(Todoist::Client.new("some_token")).all_items

      expect(result.size).to eq(4)
    end
  end

  describe "#project_name_to_id" do
    before :each do
      stub_request(:post, "https://todoist.com/API/v7/sync").
        with(:body => { "seq_no" => "0", "seq_no_global" => "0", "resource_types" => '["projects"]', "token" => "some_token" }).
        to_return(:status => 200, :body => json_response_raw("sync_projects_all"), :headers => {})
      @client = TodoistQuerynaut::Client.new(Todoist::Client.new("some_token"))
    end

    it "should resolve 'Someday Maybe' to 185594700" do
      result = @client.project_name_to_id("Someday Maybe")
      expect(result).to eq(185594700)
    end

    it "should resolve project names without case-sensitivity" do
      result = @client.project_name_to_id("SomeDAY MayBE")
      expect(result).to eq(185594700)
    end

    it "should raise ProjectNotFoundError for 'No Such Project'" do
      expect{ @client.project_name_to_id("No Such Project") }.to raise_error(ProjectNotFoundError)
    end
  end

  describe "#run" do
    before :each do
      stub_request(:post, "https://todoist.com/API/v7/query").
        with(:body => {"queries" => "[\"view all\"]", "token" => "some_token"}).
        to_return(:status => 200, :body => json_response_raw("query_view_all"), :headers => {})
      @client = TodoistQuerynaut::Client.new(Todoist::Client.new("some_token"))
    end

    it "should parse the query, execute it and return the results" do
      result = @client.run("view all")
      expect(result.size).to eq(4)
    end
  end

end

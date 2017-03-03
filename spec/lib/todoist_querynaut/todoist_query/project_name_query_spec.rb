require "spec_helper"

describe TodoistQuerynaut::TodoistQuery::ProjectNameQuery do
  describe "#value" do
    it "should return the project name (foo) of query string 'p:foo'" do
      project_name_query = TodoistQuerynaut::TodoistQuery::ProjectNameQuery.new("p:foo", 0...5)
      expect(project_name_query.value).to eq("foo")
    end

    it "should return the project name (blarg) of query string 'p:blarg'" do
      project_name_query = TodoistQuerynaut::TodoistQuery::ProjectNameQuery.new("p:blarg", 0...7)
      expect(project_name_query.value).to eq("blarg")
    end
  end

  describe "#run_query" do
    before :each do
      stub_request(:post, "https://todoist.com/API/v6/query").
        with(:body => {"queries" => "[\"view all\"]", "token" => "some_token"}).
        to_return(:status => 200, :body => json_response_raw("query_view_all"), :headers => {})
      stub_request(:post, "https://todoist.com/API/v6/sync").
        with(:body => { "seq_no" => "0", "seq_no_global" => "0", "resource_types" => '["projects"]', "token" => "some_token" }).
        to_return(:status => 200, :body => json_response_raw("sync_projects_all"), :headers => {})
    end

    it "should run a 'p:Inbox' query" do
      project_name_query = TodoistQuerynaut::TodoistQuery::ProjectNameQuery.new("p:Inbox", 0...7)
      result = project_name_query.run_query TodoistQuerynaut::Client.new(Todoist::Client.new("some_token"))

      expect(result.size).to eq(1)
      expect(result[0]["content"]).to eq("query_today_item_content")
    end
  end
end



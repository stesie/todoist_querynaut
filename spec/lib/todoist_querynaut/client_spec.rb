require "spec_helper"

describe TodoistQuerynaut::Client do
  before(:each) do
    @client = TodoistQuerynaut::Client.new(Todoist::Client.new("some_token"))
    @literalQuery = TodoistQuerynaut::TodoistQuery::LiteralQuery.new("today", 0...5)

    @receivedQueries = []
    stub_request(:post, "https://todoist.com/API/v6/query").
      to_return { |request|
	expect(request.headers["Content-Type"]).to eq("application/x-www-form-urlencoded")

	form_data = URI.decode_www_form(request.body)
	expect(form_data.assoc("token").last).to eq("some_token")

	queries = JSON.load(form_data.assoc("queries").last)
        @receivedQueries << queries

        json_response = queries.map { |query| case query
        when "today"
          JSON.load(File.read(File.join(__dir__, "fixtures/query_today.json")))
        else
          raise "Unexpected query: #{query}"
        end
        }

	{ status: 200, body: JSON.dump(json_response), headers: { "Content-type" => "application/json" } }
      }
  end

  describe "#execute_query" do
    it "should return query results" do
      result = @client.execute_query @literalQuery
      expect(result.size).to eq(1)
      expect(result[0]["content"]).to eq("query_today_item_content")
    end

  end

end

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
end



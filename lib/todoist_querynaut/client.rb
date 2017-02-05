module TodoistQuerynaut
  class Client
    def initialize(todoist)
      @todoist = todoist
    end

    def execute_query(query)
      query_string = query.get_query
      @todoist.query.search([query_string])[query_string].data
    end

  end
end


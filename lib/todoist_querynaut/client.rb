module TodoistQuerynaut
  class Client
    def initialize(todoist)
      @todoist = todoist
    end

    def search(query)
      # Todoist doesn't always set "query" on the results, hence we cannot
      # search(value)[value] here, as ruby-todoist-api Gem then assigns "nil"
      # as the hash's key.  Instead we do .first.last, to get the value of the
      # first hash entry
      @todoist.query.search(query).first.last.data
    end

    def all_items
      search "view all"
    end
  end
end


# https://stackoverflow.com/questions/61090082/rspec-api-documentation-gem-shows-binary-data-instead-of-the-response-body
module RspecApiDocumentation
  class RackTestClient < ClientBase
    def response_body
      last_response.body.encode("utf-8")
    end
  end
end
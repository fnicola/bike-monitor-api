module Error
  class PerformNotAllowed < BaseError
    def initialize
      @status = 400
      @message = "Bad Request"
    end
  end
end

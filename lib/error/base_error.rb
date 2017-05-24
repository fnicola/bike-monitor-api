module Error
  class BaseError < StandardError
    attr_reader :status, :message

    def initialize(status = nil, message = nil)
      @status = status
      @message = message
    end
  end
end

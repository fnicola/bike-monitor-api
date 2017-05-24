module Services
  class BaseService
    attr_reader :errors, :results

    def self.perform(*args)
      new(*args).perform
    end

    def initialize(options = {})
      @options = options

      @errors    = []
      @performed = false
    end

    def perform
      if allow?
        perform_if_allowed
      else
        @errors << "Will load data from the database"
      end
      @performed = true
    end

    def perform_if_not_allowed
      raise Error::PerformNotAllowed
    end

    def performed?
      @performed
    end

    def success?
      @performed && @errors.empty?
    end
  end
end

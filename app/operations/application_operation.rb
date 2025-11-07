class ApplicationOperation
  def self.call(*)
    new(*).call
  end

  def call
    raise NotImplementedError, "You must define `call` as instance method in #{self.class.name} class"
  end
end

class OperationResponse
  attr_reader :success, :data, :errors

  def initialize(success, data, errors = [])
    @data = data
    @errors = errors
    @success = success
  end

  class << self
    def success(data)
      new(true, data)
    end

    def failure(errors)
      new(false, nil, errors)
    end
  end

  def success?
    @success
  end

  def failure?
    !@success
  end
end

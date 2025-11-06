require 'ostruct'

class OperationResponse
  attr_accessor :payload, :errors

  def initialize(payload: nil, errors: [])
    @payload = deep_openstruct(payload)
    @errors = errors
  end

  def fail?
    errors.any?
  end

  def success?
    !fail?
  end

  private

  def deep_openstruct(obj)
    case obj
    when Hash
      OpenStruct.new(obj.transform_values { |v| deep_openstruct(v) })
    else
      obj
    end
  end
end

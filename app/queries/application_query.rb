class ApplicationQuery
  class_attribute :relation_class

  attr_reader :relation, :options, :user

  class << self
    def call(*)
      new(*).call
    end

    def query_on(object)
      if object.blank?
        raise StandardError,
          "#{name} class's query_on method require param as a model class name, can not be blank."
      end

      self.relation_class = object.is_a?(String) ? object.constantize : object
    end

    def base_relation
      unless relation_class
        raise StandardError,
          "#{name} class require relation class defined. Use query_on method to define it."

      end

      relation_class.all
    end
  end

  def initialize(relation, options = {}, user = nil)
    @relation = relation || self.class.base_relation
    @options = ActiveSupport::HashWithIndifferentAccess.new(options || {})
    @user = user
  end

  def call
    raise NotImplementedError, "You must define `call` as instance method in #{self.class.name} class."
  end
end

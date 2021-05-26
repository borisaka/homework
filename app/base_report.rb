# frozen_string_literal: true

class BaseReport
  # Simple DSL to reduce boilerplate code
  # usage:
  #    class Report < BaseReport
  #      field :me { 'you' }
  #    end
  # and Report.new.report will return { me: 'you' }
  class << self
    def field(field, &blk)
      fields << field
      define_method(field, &blk)
    end

    def fields
      @fields ||= []
    end
  end

  def report
    self.class.fields.each_with_object({}) { |field, report| report[field] = send(field) }
  end
end

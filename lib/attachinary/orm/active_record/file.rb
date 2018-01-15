module Attachinary
  class File < ::ActiveRecord::Base
    belongs_to :attachinariable, polymorphic: true, touch: true
    include FileMixin
  end
end

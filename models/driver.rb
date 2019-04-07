class Driver < ActiveRecord::Base
  belongs_to :event
  has_one :rider, dependent: :destroy
end

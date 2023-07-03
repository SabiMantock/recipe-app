class User < ApplicationRecord
  has_many :foods
  accepts_nested_attributes_for :foods
end

class User < ActiveRecord::Base
  has_many :points, class: PointLineItem, dependent: :destroy
end
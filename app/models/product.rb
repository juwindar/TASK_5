class Product < ActiveRecord::Base
  attr_accessible :name, :price

  def self.search(search)
    if search
      where('name LIKE ?', "%#{search}%")
    else
      scoped
    end
  end
end


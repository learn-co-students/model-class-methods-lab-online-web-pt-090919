class Boat < ActiveRecord::Base
  belongs_to  :captain
  has_many    :boat_classifications
  has_many    :classifications, through: :boat_classifications

  def self.first_five
    limit(5)
  end

  def self.dinghy
    where(Boat.arel_table[:length].lt(20))
  end

  def self.ship
    where(Boat.arel_table[:length].gt(20))
  end

  def self.last_three_alphabetically
    order(name: :desc).limit(3)
  end

  def self.without_a_captain
    where(captain: nil)
  end

  def self.sailboats
    includes('classifications').where(classifications: { name: 'Sailboat' })
  end

  def self.with_three_classifications
    # This is really complex! It's not common to write code like this
    # regularly. Just know that we can get this out of the database in
    # milliseconds whereas it would take whole seconds for Ruby to do the same.
    #
    joins(:boat_classifications).group(:name).having('count(name)=3')
  end

  def self.non_sailboats
    # where("id NOT IN (?)", self.sailboats.pluck(:id))
  end

  def self.longest
    # order('length DESC').first
  end
end

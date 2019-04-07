class Event < ActiveRecord::Base
  has_many :drivers, dependent: :destroy
  has_many :riders, dependent: :destroy

  def assign
    total_riders = Rider.where(event_id: self.event_id).pluck(:group_size).reduce(:+)
    biggest_cars = Driver.where(event_id: self.event_id).order(:seats)

    all_riders = Rider.where(event_id: self.event_id).order(:group_size)

    # Greedy take riders till everyone is riding
    size_so_far = 0
    assigned_set = Set[]
    drivers = []
    assignments = {}

    biggest_cars.each do |car|
      break if size_so_far >= total_riders

      car_size = car.seats

      rider = Rider.find_by(rider_id: car.rider_id)
      assigned_set << rider.rider_id
      if assignments[car.driver_id] != nil
        assignments[car.driver_id] << "#{rider.name} (#{rider.group_size})"
      else
        assignments[car.driver_id] = ["#{rider.name} (#{rider.group_size})"]
      end
      car_size -= rider.group_size
      size_so_far += rider.group_size

      all_riders.each do |rider|
        break if car_size <= 0
        next if rider.leaving > car.leaving
        next if assigned_set.include?(rider.rider_id)
        next if rider.group_size > car_size

        assigned_set << rider.id
        assignments[car.driver_id] << "#{rider.name} (#{rider.group_size})"
        car_size -= rider.group_size
        size_so_far += rider.group_size
      end

      drivers << car.name
    end

    reverse_assignments = {}

    assignments.each do |driver, riders|
      riders.each do |rider|
        reverse_assignments[rider] = Driver.find_by(driver_id: driver).name
      end
    end

    reverse_assignments
  end

  def drive(name, seats, group_size, leaving)
    rider = Rider.create({
      event_id: self.event_id,
      name: name,
      group_size: group_size,
      leaving: leaving
    })

    rider.save!

    driver = Driver.create({
      event_id: self.event_id,
      rider_id: rider.rider_id,
      name: name,
      seats: seats,
      leaving: leaving
    })

    driver.save!
  end

  def ride(name, group_size, leaving)
    rider = Rider.create({
      event_id: self.event_id,
      name: name,
      group_size: group_size,
      leaving: leaving
    })

    rider.save!
  end
end

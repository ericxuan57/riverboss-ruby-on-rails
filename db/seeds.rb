puts "\nSeeding States"
CSV.foreach("data/states.txt", col_sep: "\t") do |r|
  State.create(name: r[0], code: r[1])
  print "."; STDOUT.flush
end

puts "\n\nAdding rader image to states"
CSV.foreach("data/radar-states.txt", col_sep: "\t") do |r|
  s = State.find_by_code(r[0])
  s.radar_image = r[1]
  s.save
  print "."; STDOUT.flush
end

puts "\n\nAdding rivers"
$states = Hash[State.pluck(:code, :id).map {|key, value| [key, value]}]
CSV.foreach("data/rivers.txt", col_sep: "\t") do |r|
  s = River.new(site_no: r[0], name: r[1], name_short: r[2], latitude: r[3].to_f, longitude: r[4].to_f, state_id: $states[r[5].upcase])
  s.save
  print "."; STDOUT.flush
end

puts "\n\nAdding city to rivers"
CSV.foreach("data/rivers-cities.txt", col_sep: "\t") do |r|
  s = River.find_by_site_no(r[0])
  if s.blank?
    print "#{r[0]} Not Found"
    next
  end
  s.city = r[1]
  s.name_short = r[2]
  s.save
  print "."; STDOUT.flush
end

puts "\n\nAdding region to rivers"
CSV.foreach("data/regions.txt", col_sep: "\t") do |r|
  s = River.find_by_site_no(r[0])
  if s.blank?
    print "#{r[0]} Not Found"
    next
  end
  region = Region.find_by_name r[1]
  if region.blank?
    region = Region.create(name: r[1])
  end
  s.regions << region
  s.save
  print "."; STDOUT.flush
end

puts "\n\nAdding condition to rivers"
CSV.foreach("data/conditions.txt", col_sep: "\t") do |r|
  s = River.find_by_site_no(r[0])
  if s.blank?
    print "#{r[0]} Not Found"
    next
  end
  s.conditions = {low: r[1], high: r[2]}
  s.save
  print "."; STDOUT.flush
end

puts "\n\nAdding pages"
Page.create(title: "About", content: "About Content Goes Here...")
Page.create(title: "Disclaimer", content: "Disclaimer Content Goes Here...")
Page.create(title: "Advertise", content: "Advertise Content Goes Here...")
Page.create(title: "Methodology", content: "Methodology Content Goes Here...")
Page.create(title: "Improve RiverBoss", content: "Improve RiverBoss Content Goes Here...")
Page.create(title: "User Guide", content: "User Guide RiverBoss Content Goes Here...")

puts "\nAdding users"
u1 = User.new(email: "admin@riverboss.com", password: "password", admin: true)
u1.skip_confirmation!
u1.save!
u2 = User.new(email: "user@riverboss.com", password: "password", admin: false)
u2.skip_confirmation!
u2.save!

puts "\n\nSeeding completed successfully :)"

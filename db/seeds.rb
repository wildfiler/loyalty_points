# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
user = User.create()
PointLineItem.create(user: user, points: 25, source:'Joined Loyalty Program', created_at: '01/01/2013')
PointLineItem.create(user: user, points: 410, source:'Placed an order', created_at: '10/02/2013')
PointLineItem.create(user: user, points: -250, source:'Redeemed with an order', created_at: '15/02/2013')
PointLineItem.create(user: user, points: 10, source:'Wrote a review', created_at: '18/02/2013')
PointLineItem.create(user: user, points: 570, source:'Placed an order', created_at: '12/03/2013')
PointLineItem.create(user: user, points: -500, source:'Redeemed with an order', created_at: '15/04/2013')
PointLineItem.create(user: user, points: 130, source:'Make a purchase', created_at: '27/06/2013')
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

PurchaseSchedule.create([{date: '2022-03-22', enabled: false},
                        {date: '2022-03-30', time: '23:00', enabled: true},
                        {date: '2022-04-01', time: '19:00', enabled: false}])
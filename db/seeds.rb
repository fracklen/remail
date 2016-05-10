# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

customer = Customer.create(name: 'Mega Amok Spammers Inc.')

User.create(
  name: 'Filip',
  email: 'filip@filip.dk',
  password: 'filip1234',
  password_confirmation: 'filip1234',
  customer_id: customer.id
)

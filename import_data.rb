#Instantiate Event Client and connect to PredictionIO Event Server
require 'predictionio'
require 'pry'
require 'faker'
require './helpers'

include Helpers

# Define environment variables.
ENV['PIO_THREADS'] = '50' # For async requests.
ENV['PIO_EVENT_SERVER_URL'] = 'http://localhost:7070'
ENV['PIO_ACCESS_KEY'] = 'd40R_k-G2T4YBS2MmXfvmBpdDXnBDnQGjCDg9VZdH_rFldmkF7m-LSBZTG_4xBd2' # Find your access key with: `$ pio app list`.

# Create PredictionIO event @client.
client = PredictionIO::EventClient.new(
  ENV['PIO_ACCESS_KEY'], 
  ENV['PIO_EVENT_SERVER_URL'], 
  Integer(ENV['PIO_THREADS']))

N_USERS      = 20
N_ITEMS      = 100
N_CATEG      = 5
N_VIEWS      = 100
N_PURCHASES  = 20


#Creating users, items an categories
puts "Creating Users, Items and Categories"
p = Provision.new(client, {nusers: N_USERS, nitems: N_ITEMS, ncategories:N_CATEG})

#Saving Users
puts "Saving on user.db, items.db and categories.db"
p.write_in_file "users.db" ,      p.users
p.write_in_file "items.db" ,      p.items
p.write_in_file "categories.db" , p.categories

puts "*****************************"
puts "Adding Users on predictionio"
puts "*****************************"
p.add_users

puts "*****************************"
puts "Adding Items on predictionio"
puts "*****************************"
p.add_items


p.create_events('view', N_VIEWS)
p.create_events('buy', N_PURCHASES)



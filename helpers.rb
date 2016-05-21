module Helpers
  require 'faker'
  class Provision

    attr_accessor :users, :items, :categories

    def initialize client, args
      @client     = client
      @args       = args
      @users      = []
      @items      = []
      @categories = []
      @r          = Random.new(Random.new_seed)
      #Create users, items and categories
      create_users
      create_items
      create_categories
    end

    def write_in_file filename, data
      File.open(filename, 'w') do |file|
        data.each {|line| file.write(line + "\n")}
      end
    end

    def add_users
      @users.each do |user|
        response = @client.create_event(
          '$set',
          'user',
           user
        )
        puts "Event not created" unless JSON.parse(response.body)["eventId"]
      end
    end

    def add_items
      @items.each do |item|
        response = @client.create_event(
          '$set',
          'item',
           item,
           { 'properties' => { 'categories' => [@categories[@r.rand(@categories.size)] ] } }
        )
        puts "Event not created" unless JSON.parse(response.body)["eventId"]
      end
    end

    def create_events (event_type , n)
      unless  ['buy', 'view'].include?(event_type)
        puts "Event not allowed #{event_type}"
        return
      else
        puts "********************************"
        puts "Adding #{n} #{event_type} events"
        puts "********************************"
      end
      n.times do |v|
        user = @users[@r.rand(@users.size)]
        item = @items[@r.rand(@items.size)]
        response = @client.create_event(
          event_type,
          'user',
          user,
          {
            'targetEntityType' => 'item',
            'targetEntityId' => item
          }
        )
        puts "#{user} #{event_type} \"#{item}\""
      end
    end


    private
      def create_users
        @args[:nusers].times{|i| @users << Faker::Name.first_name }
      end

      def create_items
        @args[:nitems].times{|i| @items << Faker::Commerce.product_name }
      end

      def create_categories
        @args[:ncategories].times{|i| @categories << Faker::Commerce.department(1,true) }
      end

  end




end
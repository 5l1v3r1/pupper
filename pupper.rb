#!/usr/bin/env ruby
require 'discourse_api'
require 'highline/import'
require 'json'
require 'erb'
require 'launchy'
require 'rubygems'
require 'open-uri'
require 'nokogiri'
require 'base64'

require './articles.rb'
require './generate.rb'
require './printers.rb'
require './functions.rb'

# Establishes a Discourse API Object with 0x00sec
@client = DiscourseApi::Client.new("https://0x00sec.org/")
@articles = Pupper::Articles.new("articles")
$title = ""
$cooked = ""


$post_buffer = []

trap "SIGINT" do
	puts "\nBye Bye"
	exit
end

system("clear")

loop do
	puts "Welcome to Pupper - Official 0x00sec Download Tool"
	puts "Name courtesy of oaktree"
	puts "Software concieved by pry0cc\n"
	puts "Downloaded Articles: " + @articles.return().length.to_s
	# puts "Post Buffer " + $post_buffer.to_s

	choose do |menu|
		menu.prompt = "Pick an option, any option..."

		menu.choice(:Search) do
			system("clear")
			say("Alright Mr Searchy Pants...")
			Pupper.search(@client)
			Pupper.prompt(@articles, @client)
			system("clear")
		end
		menu.choice(:User) do
			system("clear")
			say("Alright Mr Searchy Pants...")
			Pupper.user_topics(@client)
			Pupper.prompt(@articles, @client)
			system("clear")
		end
		menu.choice(:Topic) do
			system("clear")
			say("Please gimme a Topic ID then...")
			Pupper.prompt(@articles, @client)
			system("clear")
		end
		menu.choice(:Latest) do
			system("clear")
			say("Outputting Latest Topics\n")
			Pupper.latest(@client)
			Pupper.prompt(@articles, @client)
			system("clear")
		end
		menu.choice(:Categories) do
			system("clear")
			say("Printing Categories\n")
			Pupper.categories(@client)
			Pupper.prompt(@articles, @client)
			system("clear")
		end
		menu.choice(:Read) do
			Pupper.generate_menu(@articles)
			Launchy.open("articles/index.html")
		end
		menu.choice(:Server) do
			Pupper.update_serv(@articles, @client)
		end
		menu.choice(:Delete) do
			system("clear")
			say("Downloaded Articles")
			Pupper.downloads(@articles)
			print "ID >> "
			id = gets.chomp
			if id != "" && (@articles.return().length > 0) && (@articles.return().length > id.to_i)
				@articles.delete(@articles.return()[id.to_i])
				say("Press enter to return to the main menu")
				gets.chomp
			elsif @articles.return.length == 0
				say("You don't have any downloaded mate.")
				say("Press enter to return to the main menu")
				gets.chomp
			end
			system("clear")
		end
	end
end

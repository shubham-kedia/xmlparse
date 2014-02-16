class CategoriesController < ApplicationController

		require 'open-uri'
		require 'rubygems'
		require 'rufus-scheduler'

	
	
	def show
		scheduler = Rufus::Scheduler.new
		scheduler.every '1h' do
			doc = Nokogiri::XML(open("http://api-product.skimlinks.com/categories?key=8bf53d38d24f389b6d35ef4014a48dad&format=xml"))
			categories = doc.search("//category")
			categories.each do |category|
				c = Category.new(:name => category.at('name').text)
				c.save
			end
			
			
		end
	end

	def new
			doc = Nokogiri::XML(open("http://api-product.skimlinks.com/categories?key=8bf53d38d24f389b6d35ef4014a48dad&format=xml"))
			categories = doc.search("//category")
			categories.each do |category|
				c = Category.new(:name => category.at('name').text)
				# puts category.at('id').content
				c.save
			end
			render :text => "XML Data Insertion Done"
	end
end

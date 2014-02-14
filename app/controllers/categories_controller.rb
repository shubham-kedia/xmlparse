class CategoriesController < ApplicationController

		require 'open-uri'
		require 'rubygems'
		require 'rufus-scheduler'

	
	
	def new
		scheduler = Rufus::Scheduler.new
		scheduler.every '1m' do
			doc = Nokogiri::XML(open("http://api-product.skimlinks.com/categories?key=8bf53d38d24f389b6d35ef4014a48dad&format=xml"))
			categories = doc.search("//category")
			categories.each do |category|
				c = Category.new(:id => category.xpath("//id"), :name => category.at('name').text)
				c.save
			end
			render :text => "OK!!Done"
		end
	end
end

class CategoriesController < ApplicationController

		require 'open-uri'
		require 'rubygems'
		require 'rufus-scheduler'

	
	
	def show
		scheduler = Rufus::Scheduler.new
		scheduler.every '2h' do
			doc = Nokogiri::XML(open("http://api-product.skimlinks.com/categories?key=8bf53d38d24f389b6d35ef4014a48dad&format=xml"))
			# doc = Nokogiri::XML(File.open("/home/sk/Documents/xmltask/category.xml"))
			@count = 0
			categories = doc.search("//category")
			
			categories.each do |category|
				@c= Category.find_or_initialize_by_category_id_and_provider_name(category.at('id').content,"skimlinks")
				if @c.name.present? && @c.name !=category.at('name').text
					@count= @count+1
				end
				@c.name = category.at('name').text
				@c.save
			end
			@l=Log.new(:records_updated => @count )
			@l.save
		end
	end

	def new
			doc = Nokogiri::XML(open("http://api-product.skimlinks.com/categories?key=8bf53d38d24f389b6d35ef4014a48dad&format=xml"))
			# puts doc.root
			categories = doc.search("//category")
			categories.each do |category|
				@c= Category.find_or_initialize_by_category_id_and_provider_name(category.at('id').content,"skimlinks")
				@c.name =category.at('name').text
				@c.save
			end
			render :text => "XML Data Insertion Done"
	end
end

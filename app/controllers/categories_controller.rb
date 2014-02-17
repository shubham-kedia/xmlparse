class CategoriesController < ApplicationController

		require 'open-uri'
		require 'rubygems'
		require 'rufus-scheduler'

	
	
	def show
		scheduler = Rufus::Scheduler.new
		scheduler.every '40s' do
			doc = Nokogiri::XML(open("http://api-product.skimlinks.com/categories?key=8bf53d38d24f389b6d35ef4014a48dad&format=xml"))
			categories = doc.search("//category")
			categories.each do |category|
				if @c=Category.find_by_category_id(category.at('id').content)
					@c.update_attribute(:name,category.at('name').text)
				else
					c = Category.new(:provider_name => "skimlinks",:category_id => category.at('id').content,:name => category.at('name').text)
					# puts category.at('id').content
					c.save
				end
			end
		end
	end

	def new
			f = File.open("/home/sk/Documents/xmltask/category.xml")
			doc = Nokogiri::XML(f)
			# puts doc.root
			categories = doc.search("//category")
			categories.each do |category|
				if @c=Category.where("category_id = ? and provider_name = ?",category.at('id').content ,"skimlinks").first
					@c.update_attribute(:name,category.at('name').text)
				else
					c = Category.new(:provider_name => "skimlinks",:category_id => category.at('id').content,:name => category.at('name').text)
					# puts category.at('id').content
					c.save
				end
			end
			render :text => "XML Data Insertion Done"
			f.close
	end
end

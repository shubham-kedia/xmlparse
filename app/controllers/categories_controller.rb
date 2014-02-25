class CategoriesController < ApplicationController

		require 'open-uri'
		require 'rubygems'
		require 'rufus-scheduler'

	
	
	def show
		scheduler = Rufus::Scheduler.new
		scheduler.every '1h' do
			doc = Nokogiri::XML(open("http://api-product.skimlinks.com/categories?key=8bf53d38d24f389b6d35ef4014a48dad&format=xml"))
			@count = 0
			categories = doc.search("//category")
			categories.each do |category|
				if @c=Category.where("category_id = ? and provider_name = ?",category.at('id').content ,"skimlinks").first
					if @c.update_attribute(:name,category.at('name').text)
						@count = @count+1
					end
				else
					c = Category.new(:provider_name => "skimlinks",:category_id => category.at('id').content,:name => category.at('name').text)
					# puts category.at('id').content
					
					c.save
				end
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
				if @c=Category.where("category_id = ? and provider_name = ?",category.at('id').content ,"skimlinks").first
					@c.update_attribute(:name,category.at('name').text)
				else
					c = Category.new(:provider_name => "skimlinks",:category_id => category.at('id').content,:name => category.at('name').text)
					# puts category.at('id').content
					c.save
				end
			end
			render :text => "XML Data Insertion Done"
	end
end

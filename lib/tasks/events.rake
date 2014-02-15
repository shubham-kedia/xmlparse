namespace :events do
			  desc "Rake task to get events data"
			  task :fetch => :environment do
				   require 'open-uri'
				    f = File.open("/home/sk/Documents/xmltask/category.xml")
				    doc = Nokogiri::XML(f)
					# doc = Nokogiri::XML(open("http://api-product.skimlinks.com/categories?key=8bf53d38d24f389b6d35ef4014a48dad&format=xml"))
					categories = doc.search("//category")
					categories.each do |category|
						c = Category.new(:id => category.xpath("//id"), :name => category.at('name').text)
						c.save
					end
					render text: "OK!!Done"
			    	# puts "#{Time.now} - Success!"
			  	end
		    end

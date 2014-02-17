class AddCategoryIdProviderNameToCategories < ActiveRecord::Migration
  def up
  	add_column "categories","provider_name",:string
  	add_column "categories","category_id",:integer
  end
  def down
  	remove_column "categories","provider_name"
  	remove_column "categories","category_id"
  end
end

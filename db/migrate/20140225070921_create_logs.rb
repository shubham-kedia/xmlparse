class CreateLogs < ActiveRecord::Migration
  def change
    create_table :logs do |t|
      t.string :records_updated

      t.timestamps
    end
  end
end

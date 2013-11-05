class CreateImages < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.string :image   
      t.integer :width
      t.integer :height
      t.text :mean_color
      t.string :format
      t.string :md5
      t.timestamps
    end
  end
end
class CreatePointLineItems < ActiveRecord::Migration
  def change
    create_table :point_line_items do |t|
      t.references :user
      t.integer :points
      t.string :source
      t.date :created_at

      t.index :user
      t.index :created_at
    end
  end
end

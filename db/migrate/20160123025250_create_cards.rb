class CreateCards < ActiveRecord::Migration
  def change
    create_table :cards do |t|
      t.text :description
      t.integer :user_id
      t.string :image_url

      t.timestamps null: false
    end
  end
end

class CreateMusics < ActiveRecord::Migration[5.1]
  def change
    create_table :musics do |t|
      t.text :link
      t.references :user, foreign_key: true
      t.boolean :banned , default: false

      t.timestamps
    end
    add_index :musics, [:user_id, :created_at]
  end
end

class CreateVideos < ActiveRecord::Migration[5.1]
  def change
    create_table :videos do |t|
      t.string :link
      t.string :title
      t.datetime :published_at
      t.integer :likes
      t.integer :dislikes
      t.string :uid
      t.references :user, foreign_key: true

      t.timestamps
    end
    add_index :videos, :uid
    add_index :videos, [:user_id, :created_at]

  end
end

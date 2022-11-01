class CreatePosts < ActiveRecord::Migration[7.0]
  def change
    change_table :posts do |t|
      t.references :user, null: false, foreign_key: true
      t.references :course, null: false, foreign_key: true
      t.text :body
      # t.timestamps
    end
  end
end

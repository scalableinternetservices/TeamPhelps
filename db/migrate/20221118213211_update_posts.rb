class UpdatePosts < ActiveRecord::Migration[7.0]
  def change
    change_table :posts do |t|
      t.references :postable, polymorphic: true
    end
  end
end

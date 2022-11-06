class UpdateComments < ActiveRecord::Migration[7.0]
  def change
    change_table :comments do |t|
      t.references :commentable, polymorphic: true
    end
  end
end

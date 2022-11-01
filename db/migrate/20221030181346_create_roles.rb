class CreateRoles < ActiveRecord::Migration[7.0]
  def change
    change_table :roles do |t|
      t.references :user, null: false, foreign_key: true
      t.references :course, null: false, foreign_key: true
      t.integer :role
      # t.timestamps
    end
  end
end

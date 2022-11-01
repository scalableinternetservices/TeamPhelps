class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    change_table :users do |t|
      t.string :name
      t.string :email

      # t.timestamps
    end
  end
end

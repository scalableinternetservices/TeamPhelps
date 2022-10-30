class CreateTables < ActiveRecord::Migration[7.0]
  def change
    create_table :comments do |t|
      t.timestamps
    end
    create_table :users do |t|
      t.timestamps
    end
    create_table :posts do |t|
      t.timestamps
    end
    create_table :courses do |t|
      t.timestamps
    end
    create_table :roles do |t|
      t.timestamps
    end
  end
end

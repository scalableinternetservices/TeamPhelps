class CreateCourses < ActiveRecord::Migration[7.0]
  def change
    change_table :courses do |t|
      t.string :name

      # t.timestamps
    end
  end
end

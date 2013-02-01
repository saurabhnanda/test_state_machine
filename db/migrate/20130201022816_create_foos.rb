class CreateFoos < ActiveRecord::Migration
  def change
    create_table :foos do |t|
      t.string :name
      t.string :description
      t.string :state

      t.timestamps
    end
  end
end

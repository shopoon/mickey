class CreateMice < ActiveRecord::Migration
  def change
    create_table :mice do |t|
      t.integer :family_id
      t.string :sex
      t.integer :sequence_id
      t.string :status

      t.timestamps
    end

    add_index :mice, [:family_id, :sex, :sequence_id], unique: true
  end
end

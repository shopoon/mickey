class CreateCouples < ActiveRecord::Migration
  def change
    create_table :couples do |t|
      t.integer :mother_id
      t.integer :father_id
      t.datetime :mated_at
      t.string :status

      t.timestamps
    end
  end
end

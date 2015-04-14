class CreateFamilies < ActiveRecord::Migration
  def change
    create_table :families do |t|
      t.string :number
      t.string :genotype
      t.date :birth
      t.integer :mother_id
      t.integer :father_id

      t.timestamps
    end

    add_index :families, [:number, :genotype], unique: true
  end
end

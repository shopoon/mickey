class CreateReserves < ActiveRecord::Migration
  def change
    create_table :reserves do |t|
      t.integer  :user_id
      t.integer  :family_id
      t.text     :mouse_ids #-> serialize
      t.datetime :reserved_at
      t.datetime :use_at
    end
  end
end

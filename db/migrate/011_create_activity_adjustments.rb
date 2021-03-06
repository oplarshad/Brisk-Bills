class CreateActivityAdjustments < ActiveRecord::Migration
  def self.up
    create_table :activity_adjustments do |t|
      
      t.integer :activity_id
      t.string    :label
      t.text    :comments

      t.timestamps
    end
  end

  def self.down
    drop_table :activity_adjustments
  end
end

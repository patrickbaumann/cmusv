class CreateDeliverables < ActiveRecord::Migration
  def self.up
     create_table :deliverables do |t|
      t.string :title
      t.integer :person_id
      t.integer :team_id
      t.boolean :individual
      t.integer :task_number
      t.string :deliverable_file_name
      t.string :deliverable_content_type
      t.integer :deliverable_file_size
      t.datetime :deliverable_updated_at
      t.string :feedback_file_name
      t.string :feedback_content_type
      t.integer :feedback_file_size
      t.datetime :feedback_updated_at
      t.timestamps
    end
  end

  def self.down
    drop_table :deliverables
  end
end

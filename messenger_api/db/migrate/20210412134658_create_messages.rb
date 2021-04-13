class CreateMessages < ActiveRecord::Migration[6.0]
  def change
    create_table :messages do |t|
      t.references :from_user, null: false, :unsigned => true, foreign_key: { to_table: :users }
      t.references :to_user,   null: false, :unsigned => true, foreign_key: { to_table: :users }
      t.string     :content,   null: false, :limit => 1000

      t.timestamps
    end

    #
    # Multi-key index to make fetching messages between two users within a date span faster.
    #    
    add_index :messages, [:from_user_id, :to_user_id, :created_at]
    add_index :messages, [:to_user_id, :from_user_id, :created_at]

    #
    # Single index on created_at to make fetching all messages within a date span faster.
    #
	  add_index :messages, :created_at
  end
end
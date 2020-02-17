class CreateBlockedTokens < ActiveRecord::Migration[5.1]
  def change
    create_table :blocked_tokens do |t|
      t.string :token

      t.timestamps
    end
    add_index :blocked_tokens, :token
  end
end

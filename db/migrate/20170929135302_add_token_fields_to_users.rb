class AddTokenFieldsToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :api_users, :token, :string

    add_column :users, :token, :string
    add_column :users, :token_exp, :datetime
  end
end

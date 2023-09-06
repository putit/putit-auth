class AddUserBelongsToOrganization < ActiveRecord::Migration[7.0]
  def change
    add_belongs_to :users, :organization
  end
end

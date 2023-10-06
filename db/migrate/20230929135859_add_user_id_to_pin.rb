class AddUserIdToPin < ActiveRecord::Migration[7.0]
  def change
    add_column :pins, :user_id, :integer
  end
end

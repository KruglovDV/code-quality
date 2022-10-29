class AddNameToRepositories < ActiveRecord::Migration[6.1]
  def change
    add_column :repositories, :name, :string
  end
end

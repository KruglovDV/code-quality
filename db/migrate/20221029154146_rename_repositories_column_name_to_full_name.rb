class RenameRepositoriesColumnNameToFullName < ActiveRecord::Migration[6.1]
  def change
    rename_column :repositories, :name, :full_name
  end
end

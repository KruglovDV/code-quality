class AddLanguageToRepositories < ActiveRecord::Migration[6.1]
  def change
    add_column :repositories, :language, :string
  end
end

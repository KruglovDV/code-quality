class AddsUniqueIndexForRepositoriesGithubIdColumn < ActiveRecord::Migration[6.1]
  def change
    add_index :repositories, :github_id, unique: true
  end
end

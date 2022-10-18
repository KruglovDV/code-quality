class AddRepositoryToCheck < ActiveRecord::Migration[6.1]
  def change
    add_reference :repository_checks, :repository, null: false, foreign_key: true, index: true
  end
end

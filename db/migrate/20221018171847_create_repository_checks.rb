class CreateRepositoryChecks < ActiveRecord::Migration[6.1]
  def change
    create_table :repository_checks do |t|
      t.string :state
      t.text :issues
      t.string :commit
      t.boolean :passed
      t.timestamps
    end
  end
end

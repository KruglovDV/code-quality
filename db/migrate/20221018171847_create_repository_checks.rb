class CreateRepositoryChecks < ActiveRecord::Migration[6.1]
  def change
    create_table :repository_checks do |t|
      t.string :state
      t.boolean :passed
      t.integer :issues

      t.timestamps
    end
  end
end

class AddAasmStateToRepositories < ActiveRecord::Migration[6.1]
  def change
    add_column :repositories, :aasm_state, :string
  end
end

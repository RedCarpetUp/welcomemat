class ChangeJobFieldsIntoJsonb < ActiveRecord::Migration[5.1]
  def change
    remove_column :jobs, :fields, :jsonb, default: '{}'
    add_column :jobs, :fields, :jsonb, default: {:entries => []}
  end
end

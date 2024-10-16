class AddWorkflowStateToAssemblee < ActiveRecord::Migration[7.1]
  def change
    add_column :assemblees, :workflow_state, :string
  end
end

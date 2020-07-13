class ChangeColumnName < ActiveRecord::Migration[6.0]
  def change
    rename_column :answers, :correct, :is_best
  end
end

class CreateVotes < ActiveRecord::Migration[6.0]
  def change
    create_table :votes do |t|
      t.integer :value

      t.belongs_to :user
      t.belongs_to :votable, polymorphic: true

      t.timestamps
    end
  end
end

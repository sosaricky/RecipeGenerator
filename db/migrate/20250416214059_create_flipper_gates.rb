class CreateFlipperGates < ActiveRecord::Migration[7.1]
  def change
    create_table :flipper_gates do |t|

      t.timestamps
    end
  end
end

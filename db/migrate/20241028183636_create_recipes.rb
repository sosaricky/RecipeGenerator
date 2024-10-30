# frozen_string_literal: true

class CreateRecipes < ActiveRecord::Migration[7.1]
  def change
    create_table :recipes do |t|
      t.string :name
      t.text :description
      t.text :ingredients, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end

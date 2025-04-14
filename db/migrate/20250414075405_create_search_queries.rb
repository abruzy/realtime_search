class CreateSearchQueries < ActiveRecord::Migration[7.1]
  def change
    create_table :search_queries do |t|
      t.references :search_session, null: false, foreign_key: true
      t.string :final_query

      t.timestamps
    end
  end
end

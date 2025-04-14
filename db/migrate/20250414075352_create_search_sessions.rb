class CreateSearchSessions < ActiveRecord::Migration[7.1]
  def change
    create_table :search_sessions do |t|
      t.string :ip_address

      t.timestamps
    end
  end
end

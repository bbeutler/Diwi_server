class CreateTermsAcceptance < ActiveRecord::Migration[5.2]
  def change
    create_table :terms_acceptances do |t|
      t.datetime :accepted_at
      t.references :consumer, foreign_key: true
      t.string :remote_ip

      t.timestamps
    end
  end
end

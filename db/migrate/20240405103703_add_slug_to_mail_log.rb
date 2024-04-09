class AddSlugToMailLog < ActiveRecord::Migration[7.1]
  def change
    add_column :mail_logs, :slug, :string
    add_index :mail_logs, :slug, unique: true

    MailLog.find_each(&:save)
  end
end

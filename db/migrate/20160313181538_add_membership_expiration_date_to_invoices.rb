class AddMembershipExpirationDateToInvoices < ActiveRecord::Migration
  def change
    add_column :invoices, :membership_expiration_date, :datetime
  end
end

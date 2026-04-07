class AddPortalUsersToBookings < ActiveRecord::Migration[7.0]
  def change
    add_reference :bookings, :customer_user, foreign_key: { to_table: :users }
    add_reference :bookings, :group_leader_user, foreign_key: { to_table: :users }
  end
end

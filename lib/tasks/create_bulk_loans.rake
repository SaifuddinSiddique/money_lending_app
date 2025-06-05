# lib/tasks/loans_bulk_create.rake

namespace :loans do
  desc "Create 100,000 dummy loans efficiently"
  task bulk_create: :environment do
    require "activerecord-import"

    batch_size = 1000
    total_loans = 100_000
    loans = []

    users = User.all
    admin_users = User.where(role: "admin")

    unless users.any? && admin_users.any?
      puts "You need existing users and admins in the DB."
      next
    end

    total_loans.times do |i|
      amount = rand(10_000..100_000)
      interest_rate = rand(5.0..15.0).round(2)

      loans << Loan.new(
        user_id: users.sample.id,
        admin_id: admin_users.sample.id,
        amount: amount,
        interest_rate: interest_rate,
        total_amount: amount,
        state: "requested",
        opened_at: nil
      )

      # Import in batches
      if loans.size >= batch_size
        Loan.import loans
        puts "Inserted batch up to record #{i + 1}"
        loans.clear
      end
    end

    # Insert remaining records
    Loan.import loans if loans.any?
    puts "Successfully inserted #{total_loans} loans!"
  end
end

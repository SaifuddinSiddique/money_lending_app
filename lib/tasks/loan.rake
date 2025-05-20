# lib/tasks/loan.rake
namespace :loan do
    desc "Calculate interest for open loans"
    task calculate_interest: :environment do
        CalculateInterestJob.perform_now
    end
end

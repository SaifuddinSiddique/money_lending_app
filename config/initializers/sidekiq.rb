require "sidekiq/cron/job"

Sidekiq::Cron::Job.create(
  name: "Calculate interest on loans - every 5 minutes",
  cron: "*/5 * * * *",  # This runs the job every 5 minutes
  class: "CalculateInterestJob"
)

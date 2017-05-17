namespace :custom_tasks do
  desc "Set of custom tasks"
  task sidekiq_predeploy: :environment do
  	Sidekiq::ProcessSet.new.each(&:quiet!)
  end

end

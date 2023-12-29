require 'rufus-scheduler'

s = Rufus::Scheduler.singleton

s.every '1h' do

  system('bundle exec rake accuweather:get_24h')
end
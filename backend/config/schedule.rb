# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# docker環境を前提に書き換える
docker_command = "cd /home/ubuntu/scmnext && sudo /usr/local/bin/docker-compose exec -T backend"
job_type :rake,    "#{docker_command} rails :task --silent :output"
job_type :runner,  "#{docker_command} rails runner ':task' :output"
job_type :script,  "#{docker_command} bundle exec script/:task :output"

# 託送データのダウンロードと速報値当日データの取り込み
every 15.minute do # 1.minute 1.day 1.week 1.month 1.year is also supported
  rake 'dlt:download dlt:import:today'
end

# 旧システムデータの取り込み及びJEPXデータの取り込み
every 1.day, at: '1:00' do
  rake 'legacy:convert jepx:download:imbalance_beta jepx:download:spot_trade'
end

# 速報値過去データの取り込み
every 1.day, at: '9:00' do
  rake 'dlt:import:past'
end

# 確定値の取り込み
every 1.day, at: '20:00' do
  rake 'dlt:import:fixed'
end

# Learn more: http://github.com/javan/whenever

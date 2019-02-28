namespace :utility do
  desc 'レイアウト修正'
  task fix_layout: :environment do |_task, _args|
    sh 'rubocop --fix-layout app lib'
  end

  desc '構文チェック'
  task lint: :environment do |_task, _args|
    sh 'rubocop --rails --auto-correct app lib'
  end
end

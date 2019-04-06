module TaskLogging
  def task(*args)
    Rake::Task.define_task(*args) do |task|
      if block_given?
        Rails.logger.info "[#{task.name}] started"
        begin
          yield(task)
          Rails.logger.info "[#{task.name}] finished"
        rescue StandardError => exception
          Rails.logger.error "[#{task.name}] failed"
          Rails.logger.error exception
          raise exception
        end
      end
    end
  end
end

# Override Rake::DSL#task to inject logging
extend TaskLogging

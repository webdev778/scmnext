module TaskLogging
  def task(*args)
    Rake::Task.define_task(*args) do |task|
      if block_given?
        Rails.logger.debug "[#{task.name}] started"
        begin
          yield(task)
          Rails.logger.debug "[#{task.name}] finished"
        rescue StandardError => exception
          Rails.logger.debug "[#{task.name}] failed"
          raise exception
        end
      end
    end
  end
end

# Override Rake::DSL#task to inject logging
extend TaskLogging

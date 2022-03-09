class BaseWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'default', retry: 2

  def perform(*args)
    args
  end
end
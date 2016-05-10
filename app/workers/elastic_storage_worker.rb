class ElasticStorageWorker
  include Sidekiq::Worker
  def perform(index, type, documents)
    ElasticStorageService.new(
      index, type, documents
    ).process
  end
end

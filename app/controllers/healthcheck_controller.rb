class HealthcheckController < ActionController::Base
  # Not inheriting from ApplicationController here so we don't need OAuth
  # authentication to access the health check

  respond_to :json

  def check
    health_status = {"checks" => {}}
    health_status["checks"]["schedule_queue"] = schedule_queue_result
    health_status["status"] = health_status["checks"]["schedule_queue"]["status"]
    respond_with health_status
  end

private

  def schedule_queue_result
    scheduled_editions = Edition.scheduled_for_publishing.count
    queue_size = Sidekiq::Stats.new.scheduled_size

    if scheduled_editions == queue_size
      {"status" => "ok"}
    else
      {
        "status" => "warning",
        "message" => "#{scheduled_editions} scheduled edition(s); #{queue_size} item(s) queued"
      }
    end
  end
end

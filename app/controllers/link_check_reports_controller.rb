class LinkCheckReportsController < ApplicationController
  before_filter :find_reportable

  def create
    service = LinkCheckReportCreator.new(
      edition: @reportable
    )

    @report = service.call

    respond_to do |format|
      format.js { render 'link_check_reports/create' }
      format.html { redirect_to edition_url(@reportable.id) }
    end
  end

private

  def find_reportable
    @reportable = Edition.find(params[:edition_id])
  end
end

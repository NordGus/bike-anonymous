class Api::License::ReportsController < ApplicationController
  include Authenticable

  before_action :authorize_owner

  def nightly
    ::License::ReportsMailer.with(user_id: current_user.id).nightly_report.deliver_later

    head(:ok)
  end
end

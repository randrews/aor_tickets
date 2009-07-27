class TicketController < ApplicationController

  def index
    @query = params[:query]
    flash[:error]=nil

    unless @query.blank?
      begin
        ids = QueryEvaluator.evaluate_query(@query)
        @tickets = Ticket.find(:all, :conditions=>["id in (?)",ids])
      rescue
        flash[:error] = $!.message
        @tickets = []
      end
    else
      @tickets = Ticket.all
    end
  end
end

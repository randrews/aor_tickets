class TicketController < ApplicationController

  def index
    @query = params[:query]

    begin
      ids = QueryEvaluator.evaluate_query(@query)
      @tickets = Ticket.find(:all, :conditions=>["id in (?)",ids])
    rescue
      @tickets = Ticket.all
    end
  end
end

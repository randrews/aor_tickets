class TicketController < ApplicationController

  def index
    @query = params[:query]
    @tickets = Ticket.all
  end
end

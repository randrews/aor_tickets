class QueryEvaluator < Dhaka::Evaluator
  self.grammar=QueryGrammar

  attr_accessor :results

  ##################################################
  ### Convenience interface method #################
  ##################################################

  def self.evaluate_query query
    ev = QueryEvaluator.new
    parse_tree = QueryParser.parse(QueryLexer.lex(query))
    ev.evaluate(parse_tree)
    ev.results
  end

  # All the IDs that there are (needed to do negation clauses)
  def universe
    @universe ||= Ticket.all.map(&:id)
  end

  define_evaluation_rules do

    ##################################################
    ### Valid types of queries #######################
    ##################################################

    # Find things given a real query
    for_query do
      self.results = evaluate(child_nodes[0])
    end

    # Find just one ticket by its ID
    for_find_id do
      id = child_nodes[0].token.value.to_i
      self.results = (Ticket.find_by_id(id) ? [id] : [])
    end

    ##################################################
    ### Evaluating clauses ###########################
    ##################################################

    # A clause for whether a query has a tag
    for_tag do
      tagname=child_nodes[0].token.value

      Tag.find(:all, :conditions=>{:name=>tagname}).map(&:ticket_id)
    end

    # Comparing a field to a value
    for_comparison do
      field=child_nodes[0].token.value
      comparator=evaluate(child_nodes[1])
      value=evaluate(child_nodes[2])

      case field
      when "owner"
        # special case for owner, since it links to another table
        users = User.find(:all, :conditions=>["login #{comparator} ?",value]).map(&:id)
        Ticket.find(:all, :conditions=>["user_id in (?)",users]).map(&:id)
      else
        Ticket.find(:all, :conditions=>["#{field} #{comparator} ?",value]).map(&:id)
      end
    end

    ##################################################
    ### Combining clauses ############################
    ##################################################

    # Handling the and/or/not operators
    for_intersection do
      evaluate(child_nodes[0]) & evaluate(child_nodes[2])
    end

    for_union do
      evaluate(child_nodes[0]) | evaluate(child_nodes[2])
    end

    for_negated do
      universe - evaluate(child_nodes[1])
    end

    # Queries consisting of a single clause
    # All queries eventually recurse down to this.
    for_oneclause do
      evaluate child_nodes[0]
    end

    # Queries in parentheses
    for_parenthesized_query do
      evaluate child_nodes[1]
    end

    ##################################################
    ### Operators (evaluate to themselves) ###########
    ##################################################

    ["eq_comparator", "like_comparator"].each do |production|
      self.send "for_#{production}" do
        child_nodes[0].token.value
      end
    end

    ##################################################
    ### Atmos (evaluate to themselves) ###############
    ##################################################

    for_string_value do
      child_nodes[0].token.value
    end

    for_number_value do
      child_nodes[0].token.value.to_i
    end
  end
end

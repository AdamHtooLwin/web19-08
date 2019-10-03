class Ps2Controller < ApplicationController
  def index

  end

  def quotation
    # @categories = Quotation.pluck(:category).uniq
    if params[:quotation]
      if params[:quotation][:new_category] == ""
        @quotation = Quotation.new( :author_name => params[:quotation][:author_name], :quote => params[:quotation][:quote] )
        @quotation.category = params[:quotation][:category]
        if @quotation.save
          flash[:notice] = 'Quotation was successfully created.'
          @quotation = Quotation.new
        end
      else
        @quotation = Quotation.new( :author_name => params[:quotation][:author_name], :quote => params[:quotation][:quote] )
        @quotation.category = params[:quotation][:new_category]
        if @quotation.save
          puts "HELLLLLLLLLLLLLLLLLLLLOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO"
          flash[:notice] = 'Quotation was successfully created.'
          @quotation = Quotation.new
        end
      end

    else
      @quotation = Quotation.new
    end
    if params[:sort_by] == "date"
      @quotations = Quotation.order(:created_at)
    elsif params[:search]
      search_term = "%" + params[:search] + "%"
      puts search_term
      @quotations = Quotation.where("lower(quote) like ? OR lower(author_name) like ?", search_term.downcase, search_term.downcase)
    else
      @quotations = Quotation.order(:category)
    end
  end

  private

  def quotation_params
    params.require(:quotation).permit(:author_name, :new_category, :category, :quote)
  end
end

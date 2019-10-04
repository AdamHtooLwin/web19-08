class Ps2Controller < ApplicationController
  def index

  end

  def kill_quotation
    killed_id = params[:killed]

    if cookies[:killed]
      cookies[:killed] = cookies[:killed] + "," + "#{killed_id}"
    else
      cookies[:killed] = "#{killed_id}"
    end

    puts cookies[:killed]

    redirect_to ps2_quotation_path
  end

  def reset_kills
    if cookies[:killed]
      cookies.delete :killed
    end

    redirect_to ps2_quotation_path
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

    if cookies[:killed]
      killed_ids = cookies[:killed].split(',')
    else
      killed_ids = []
    end

    if params[:sort_by] == "date"
      @quotations = Quotation.order(:created_at).where.not(id: killed_ids)
    elsif params[:search]
      search_term = "%" + params[:search] + "%"
      puts search_term
      @quotations = Quotation.where("lower(quote) like ? OR lower(author_name) like ?", search_term.downcase, search_term.downcase).where.not(id: killed_ids)
    else
      @quotations = Quotation.order(:category).where.not(id: killed_ids)
    end
  end

  def export_json
    quotation = Quotation.all.as_json
    quotation = JSON.pretty_generate(quotation)
    send_data(quotation, :filename => "quotation.json" )
    redirect_to ps2_quotation_path
  end

  def export_xml
    quotation = Quotation.all.as_json
    quotation = quotation.to_xml
    send_data(quotation, :filename => "quotation.xml")
  end

  def import_xml
    puts "Hello from import_xml"
    uploaded_file = params[:file]
    File.open(Rails.root.join('public', uploaded_file.original_filename), 'wb') do |file|
      file.write(uploaded_file.read)
    end
    doc = File.open(Rails.root.join('public', uploaded_file.original_filename)) { |f| Nokogiri::XML(f) }
    objects = doc.css('object')
    objects.each do |object|
      author_name = object.css('author-name').inner_text
      category = object.css('category').inner_text
      quote = object.css('quote').inner_text
      puts author_name
      @quotation = Quotation.new( :author_name => author_name, :quote => quote, :category => category )
      @quotation.save
    end
    redirect_to ps2_quotation_path
  end

  private

  def quotation_params
    params.require(:quotation).permit(:author_name, :new_category, :category, :quote)
  end
end

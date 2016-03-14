require 'roo'
class ArticlesController < ApplicationController
  before_action :check_current_user, only: [:new, :create, :edit, :update, :destroy, :index]
  def index
    @articles = Article.status_active
    @articles = Article.all
    @articles = Article.paginate(:page => params[:page], :per_page => 5)
    # @articles = Article.search(params[:search]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 5, :page => params[:page])
  end

  def new
    @article = Article.new
  end

  def edit
    @article = Article.find_by_id(params[:id])
  end

  def create
    @article = Article.new(params_article)
    if @article.save
      flash[:notice] = "Success Add Records"
      redirect_to action: 'index'
    else
      flash[:error] = "data not valid"
      render 'new'
    end
  end
  def show
    @article = Article.find_by_id(params[:id])
    @comments = @article.comments.order("id desc")
    @comment = Comment.new
  end

  def update
    @article = Article.find_by_id(params[:id])
    if @article.update(params_article)
      flash[:notice] = "Success Update Records"
      redirect_to action: 'index'
    else
      flash[:error] = "data not valid"
      render 'edit'
    end
  end

  def destroy
    @article = Article.find_by_id(params[:id])
    if @article.destroy
      flash[:notice] = "Success Delete a Records"
      redirect_to action: 'index'
    else
      flash[:error] = "fails delete a records"
      redirect_to action: 'index'
    end
  end
  
  # yang baru
  def export
    @as_article = params[:article].present?
    @article = Article.find(params[:article]) if @as_article
  end

include Downloadable
      
  def download_file
    @articles = Article.all
    respond_to do |format|
      format.xls
    end
    
 def create
   render "articles_create_path/report.xlsx.axlsx"
 end
    # if params[:article].present?
      # @articles = Article.where(:id => params[:article])
      # @comments = @articles.first.comments
    # else
      # @articles = Article.all
      # @comments = Comment.all
    # end
    
    # xlsx = Axlsx::Package.new
    # wb = xlsx.workbook
    # wb.add_worksheet(name: "Articles") do |sheet|
      # sheet.add_row ["ID", "Title", "Body", "Created At", "Updated At"]
      # @articles.each do |article|
        # sheet.add_row [article.id, article.title, article.created_at, article.updated_at]
      # end
    # end
    # wb.add_worksheet(name: "Comments") do |sheet|
      # sheet.add_row ["ID", "Article ID", "Body", "Created At", "Updated At"]
      # @comments.each do |comment|
        # sheet.add_row [comment.id, comment.article_id, comment.body, comment.created_at, comment.updated_at]
      # end
    # end
# 
    # send_data Article.to_xlsx.to_stream.read, :filename => 'articless.xlsx', :type => "application/vnd.openxmlformates-officedocument.spreadsheetml.sheet"
  end
  def export_from_file
  render 'export_file'
  end

  def import_from_file
  render 'import_file'
  end
# post
 def import
    raise 'Nothing to import' unless params[:sample].present?
    total_row = 0
    spreadsheet = open_spreadsheet(params[:sample])

    spreadsheet.sheets.each_with_index do |sheet, index|
      spreadsheet.default_sheet = spreadsheet.sheets[index]

      header = Array.new
      spreadsheet.row(1).each { |row| header << row.downcase.tr(' ', '_') }
      (2..spreadsheet.last_row).each do |i|
        row = Hash[[header, spreadsheet.row(i)].transpose]
        new_row = eval("#{spreadsheet.default_sheet.singularize}").new(row)

        # Check existance on database, if the record already exist, destroy it with it's comment
        checker = eval("#{spreadsheet.default_sheet.singularize}").find(row['id'].to_i) rescue nil
        checker.destroy unless checker.nil?

        raise 'Failed to save, maybe invalid column' unless new_row.save!

        total_row += 1
      end
    end

    respond_to do |f|
      f.html { redirect_to articles_path, :notice => "Importing #{total_row} records successfully" }
    end
  end

  private
# yang ini juga

def get_file_type(file) 
  File.extname(file.original_filename).gsub('.','') 
end
def open_spreadsheet(file)
   extension = get_file_type(file)
      case File.extname(file.original_filename)
        when '.csv' then Roo::Excel.new(file.path, packed: true, file_warning: :ignore)
        when '.xls' then Roo::Excel.new(file.path, packed: true, file_warning: :ignore)
        when '.xlsx' then Roo::Excel.new(file.path, packed: true, file_warning: :ignore)
        else raise "Unknown file type: #{file.original_filename}"
      end
    end
  def params_article
    params.require(:article).permit(:title, :content, :status)
  end
end

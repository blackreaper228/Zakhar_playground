class Admin::CommentsController < ApplicationController
  load_and_authorize_resource
  before_action :set_comment, only: %i[ show edit update destroy ]
  # before_action :set_pin, only: %i[ show new edit create update destroy ]

  # GET /comments or /comments.json
  def index
    @comments = Comment.all
  end

  # GET /comments/1 or /comments/1.json
  def show
  end

  # GET /comments/new
  def new
    @comment = Comment.new
  end

  # GET /comments/1/edit
  def edit
  end

  # POST /comments or /comments.json
  def create
    @pin = Pin.find(params[:pin_id])
    @comment = @pin.comments.new(comment_params)
    # @comment = @pin.comments.new(body: params[:comment][:body], user_id: current_user.id)

    respond_to do |format|
      if @comment.save
        format.html { redirect_to admin_pin_url(@pin), notice: "Comment was successfully created." }
        format.json { render :show, status: :created, location: @comment }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /comments/1 or /comments/1.json
  def update
    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to admin_pin_url(@comment.pin), notice: "Comment was successfully updated." }
        format.json { render :show, status: :ok, location: @comment }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1 or /comments/1.json
  def destroy
    @pin = @comment.pin
    @comment.destroy

    respond_to do |format|
      format.html { redirect_to admin_pin_url(@pin), notice: "Comment was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end

    def set_pin
      @pin = Pin.find(params[:pin_id])
    end

    # Only allow a list of trusted parameters through.
    def comment_params
      params.require(:comment).permit(:body).merge(user_id: current_user.id)
    end
end

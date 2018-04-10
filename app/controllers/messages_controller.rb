class MessagesController < ApplicationController
  # GET /messages
  # gather a list of all existing messages for the given order
  def index
    @order = Order.find(params[:order])
    authorize @order, :show?
    @messages = @order.messages
  end

  # GET /messages/new
  # restful action for creating a new message instance
  def new
    authorize Message
    @message = Message.new
  end

  # POST /messages
  # action for creating a new message instance from given parameters
  def create
    authorize Message
    # create message object from given parameters
    @message = Message.new(message_params)
    # get the order that the message is for
    @order = Order.find(message_params[:order_id])

    respond_to do |format|
      begin
        # wrap following actions in a transaction, so message and order are only saved if both are possible
        ActiveRecord::Base.transaction do
          @message.save!
          @order.update_attributes!(status: message_params[:new_status])
          # send out the email to the customer
          StatusMailer.status_update(@order.user_id, @order.id, @message.subject, @message.body).deliver
          format.html { redirect_to order_path(id: message_params[:order_id]), notice: 'The message has been sent.' }
          format.json { render json: @message, status: :created, location: @message }
        end
      rescue ActiveRecord::ActiveRecordError => e
        format.html { render :new }
        format.json { render json: @message.errors, status: :unprocessable_entity }
        format.js   { render :new, content_type: 'text/javascript' }
      end
    end
  end

  private

  # Only allow the whitelisted parameters.
  def message_params
    params.require(:message).permit(:order_id, :subject, :body, :new_status)
  end
end
